import FDependencyInjector
import Foundation

/// Repository responsible for orchestrating Women Care Points data.
///
/// This repository coordinates data retrieval from:
/// - Remote data source (home)
/// - Local data source (in-memory cache)
///
/// It also handles mapping between data entities and domain models.
final class WomenCarePointRepository: @unchecked Sendable,
                                     WomenCarePointRepositoryContract {

    /// Remote data source used to fetch home information.
    let homeRemoteDataSource:WomenCarePointHomeRemoteDataSourceContract
    /// Local data source used to cache home information.
    let homeLocalDataSource:WomenCarePointHomeLocalDataSourceContract
    /// Mapper used to convert between data entities and domain models.
    let getWomenCarePointEntityMapper:WomenCarePointMapperContract

    /// Required initializer for dependency injection.
    ///
    /// All dependencies are resolved automatically using the injector.
    public required init() {
        @Injected var homeRemoteDataSource:WomenCarePointHomeRemoteDataSourceContract
        @Injected var homeLocalDataSource:WomenCarePointHomeLocalDataSourceContract
        @Injected var getWomenCarePointEntityMapper:WomenCarePointMapperContract
        self.homeRemoteDataSource = homeRemoteDataSource
        self.homeLocalDataSource = homeLocalDataSource
        self.getWomenCarePointEntityMapper = getWomenCarePointEntityMapper
    }

    /// Designated initializer intended mainly for testing or manual dependency injection.
    ///
    /// - Parameters:
    ///   - homeRemoteDataSource: Remote data source for home information.
    ///   - homeLocalDataSource: Local data source for caching home information.
    ///   - getWomenCarePointEntityMapper: Mapper used to convert entities and models.
    init(
        homeRemoteDataSource:WomenCarePointHomeRemoteDataSourceContract,
        homeLocalDataSource:WomenCarePointHomeLocalDataSourceContract,
        getWomenCarePointEntityMapper:WomenCarePointMapperContract
    ) {
        self.homeRemoteDataSource = homeRemoteDataSource
        self.homeLocalDataSource = homeLocalDataSource
        self.getWomenCarePointEntityMapper = getWomenCarePointEntityMapper
    }

    /// Retrieves the home information for Women Care Points.
    ///
    /// The repository first attempts to load cached data from the local data source.
    /// If no local data is available, it falls back to the remote data source.
    ///
    /// - Returns: A `WomenCarePointModel` containing home information.
    /// - Throws: An error if remote fetching or mapping fails.
    public func getWomanCarePointHomeInformation() async throws -> WomenCarePointModel {
        let localCenters = try await getCentersHomeInfoFromLocalData()
        if localCenters.data.isEmpty {
            return try await getCentersHomeInfoFromRemoteData()
        }
        return localCenters
    }

    /// Saves home information into the local data source.
    ///
    /// - Parameter centers: Domain model containing Women Care Points home information.
    /// - Throws: An error if mapping fails.
    public func saveHomeDataToLocal(centers:WomenCarePointModel) async throws {
        let entity = try getWomenCarePointEntityMapper.map(centers)
        await homeLocalDataSource.setLocalHomeInformation(entity: entity)
    }

}

private extension WomenCarePointRepository {

    /// Fetches home information from the remote data source and maps it into a domain model.
    func getCentersHomeInfoFromRemoteData() async throws -> WomenCarePointModel {
        let centersEntity = try await homeRemoteDataSource.getHomeInformation()
        return try getWomenCarePointEntityMapper.map(centersEntity)
    }

    /// Fetches home information from the local data source and maps it into a domain model.
    ///
    /// If no local data is available, an empty model is returned.
    func getCentersHomeInfoFromLocalData() async throws -> WomenCarePointModel {
        if let centersEntity = await homeLocalDataSource.getLocalHomeInformation() {
            return try getWomenCarePointEntityMapper.map(centersEntity)
        } else {
            return WomenCarePointModel(data: [])
        }
    }

}
