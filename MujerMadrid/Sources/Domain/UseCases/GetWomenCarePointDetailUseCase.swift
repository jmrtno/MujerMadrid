import Foundation
import FDependencyInjector

/// Contract that defines the interface for the GetWomenCarePointDetail use case.
protocol GetWomenCarePointDetailUseCaseContract: UseCaseContract, Sendable {

    /// Executes the use case to fetch detailed information for a specific care point.
    ///
    /// - Parameter params: Parameters containing the care point identifier.
    /// - Returns: A `WomenCarePointModel` containing detailed information.
    /// - Throws: An error if data fetching or mapping fails.
    func run(_ params: GetWomenCarePointDetailParameters) async throws -> WomenCarePointModel
}

/// Parameters required to execute `GetWomenCarePointDetailUseCase`.
public class GetWomenCarePointDetailParameters {

    /// Unique identifier of the care center.
    public let centerId: String

    /// Initializes the parameters with a care center identifier.
    ///
    /// - Parameter centerId: Unique identifier of the care center.
    public init(centerId: String) {
        self.centerId = centerId
    }
}

/// Use case implementation responsible for fetching detailed information
/// for a specific Women Care Point.
class GetWomenCarePointDetailUseCase: GetWomenCarePointDetailUseCaseContract, @unchecked Sendable {

    /// Repository used to access Women Care Point data.
    let womenCarePointRepository: WomenCarePointRepositoryContract

    /// Required initializer using dependency injection.
    required init() {
        @Injected var womenCarePointRepository: WomenCarePointRepositoryContract
        self.womenCarePointRepository = womenCarePointRepository
    }

    /// Executes the use case.
    ///
    /// - Parameter params: Parameters containing the care point identifier.
    /// - Returns: A `WomenCarePointModel` with detailed information.
    /// - Throws: An error if data fetching or mapping fails.
    public func run(_ params: GetWomenCarePointDetailParameters) async throws -> WomenCarePointModel {
        let centersDetail = try await womenCarePointRepository.getWomanCarePointDetailInformation(centerId: params.centerId)
        return WomenCarePointModel(data: centersDetail.data)
    }
}
