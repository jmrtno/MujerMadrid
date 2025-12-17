import FDependencyInjector
import Foundation

/// Contract that defines the remote data source responsible for retrieving
/// detailed information of a Women Care Point.
public protocol WomenCarePointDetailRemoteDataSourceContract: Instanciable {

    /// Fetches the detailed information of a specific Women Care Point from a remote source.
    ///
    /// - Parameter centerId: The unique identifier of the care center.
    /// - Returns: A `WomenCarePointDataEntity` containing the detailed information of the center.
    /// - Throws: An error if the network request fails or the response cannot be mapped.
    func getDetailInformation(centerId: String) async throws -> WomenCarePointDataEntity
}

/// Default implementation of `WomenCarePointDetailRemoteDataSourceContract`.
///
/// This data source retrieves the detail information from the remote API
/// and maps the received data into a domain-friendly entity.
final class WomenCarePointDetailRemoteDataSource: WomenCarePointDetailRemoteDataSourceContract {

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

    /// Retrieves and maps the detailed information of a Women Care Point.
    ///
    /// This method performs a network request to fetch the detail information,
    /// then maps the received data into a `WomenCarePointDataEntity`.
    ///
    /// - Parameter centerId: The unique identifier of the care center.
    /// - Returns: A `WomenCarePointDataEntity` with the mapped detail information.
    /// - Throws: An error if the request execution or data mapping fails.
    public func getDetailInformation(centerId: String) async throws -> WomenCarePointDataEntity {
        let resultAPI: Data = try await womenCarePointAPI
            .getWomanCarePointDetailInfo(centerId: centerId)
            .execute()

        return try womenCarePointMapper.map(resultAPI)
    }
}
