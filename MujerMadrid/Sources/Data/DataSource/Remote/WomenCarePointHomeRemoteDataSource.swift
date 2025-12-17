import FDependencyInjector
import Foundation

/// Contract that defines the remote data source responsible for retrieving
/// home information related to Women Care Points.
public protocol WomenCarePointHomeRemoteDataSourceContract: Instanciable {

    /// Fetches the home information for Women Care Points from a remote source.
    ///
    /// - Returns: A `WomenCarePointDataEntity` containing the home information.
    /// - Throws: An error if the network request fails or the response cannot be mapped.
    func getHomeInformation() async throws -> WomenCarePointDataEntity
}

/// Default implementation of `WomenCarePointHomeRemoteDataSourceContract`.
///
/// This data source retrieves the home information from the remote API
/// and maps the received data into a domain-friendly entity.
final class WomenCarePointHomeRemoteDataSource: WomenCarePointHomeRemoteDataSourceContract {

    /// Mapper responsible for converting raw API data into `WomenCarePointDataEntity`.
    var womenCarePointMapper: WomenCarePointMapperContract

    /// API used to perform network requests related to Women Care Points.
    var womenCarePointAPI: WomenCarePointAPIContract

    /// Required initializer for dependency injection.
    ///
    /// Dependencies are resolved automatically using the injector.
    public required init() {
        @Injected var womenCarePointMapper: WomenCarePointMapperContract
        @Injected var womenCarePointAPI: WomenCarePointAPIContract
        self.womenCarePointMapper = womenCarePointMapper
        self.womenCarePointAPI = womenCarePointAPI
    }

    /// Designated initializer intended mainly for testing or manual dependency injection.
    ///
    /// - Parameters:
    ///   - womenCarePointMapper: Mapper used to transform raw API data into domain entities.
    ///   - womenCarePointAPI: API used to fetch remote Women Care Point information.
    init(womenCarePointMapper: WomenCarePointMapperContract,
         womenCarePointAPI: WomenCarePointAPIContract) {
        self.womenCarePointMapper = womenCarePointMapper
        self.womenCarePointAPI = womenCarePointAPI
    }

    /// Retrieves and maps the home information for Women Care Points.
    ///
    /// This method performs a network request to fetch the home information,
    /// then maps the received data into a `WomenCarePointDataEntity`.
    ///
    /// - Returns: A `WomenCarePointDataEntity` with the mapped home information.
    /// - Throws: An error if the request execution or data mapping fails.
    public func getHomeInformation() async throws -> WomenCarePointDataEntity {
        let resultAPI: Data = try await womenCarePointAPI
            .getWomanCarePointHomeInfo()
            .execute()

        return try womenCarePointMapper.map(resultAPI)
    }
}
