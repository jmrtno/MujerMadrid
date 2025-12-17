import Foundation
import FDependencyInjector

/// Contract that defines the interface for the GetWomenCarePointHome use case.
protocol GetWomenCarePointHomeUseCaseContract: UseCaseContract, Sendable {

    /// Executes the use case to fetch home information for all Women Care Points.
    ///
    /// - Returns: A `WomenCarePointModel` containing home information.
    /// - Throws: An error if data fetching or mapping fails.
    func run() async throws -> WomenCarePointModel
}

/// Use case implementation responsible for fetching home information
/// for all Women Care Points and caching it locally.
class GetWomenCarePointHomeUseCase: GetWomenCarePointHomeUseCaseContract, @unchecked Sendable {

    /// Repository used to access Women Care Point data.
    let womenCarePointRepository: WomenCarePointRepositoryContract

    /// Required initializer using dependency injection.
    required init() {
        @Injected var womenCarePointRepository: WomenCarePointRepositoryContract
        self.womenCarePointRepository = womenCarePointRepository
    }

    /// Executes the use case.
    ///
    /// This method fetches home information from the repository,
    /// caches it locally, and returns the domain model.
    ///
    /// - Returns: A `WomenCarePointModel` containing home information.
    /// - Throws: An error if data fetching, mapping, or caching fails.
    public func run() async throws -> WomenCarePointModel {
        let centers = try await womenCarePointRepository.getWomanCarePointHomeInformation()
        try await womenCarePointRepository.saveHomeDataToLocal(centers: centers)
        return WomenCarePointModel(data: centers.data)
    }
}
