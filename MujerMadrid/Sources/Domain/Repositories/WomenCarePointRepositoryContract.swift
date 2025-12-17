import FDependencyInjector

/// Contract that defines the interface for a repository handling
/// Women Care Points data.
protocol WomenCarePointRepositoryContract: Instanciable {

    /// Retrieves the home information for all Women Care Points.
    ///
    /// The repository may use a combination of local cache and remote data.
    ///
    /// - Returns: A `WomenCarePointModel` containing home information.
    /// - Throws: An error if data fetching or mapping fails.
    func getWomanCarePointHomeInformation() async throws -> WomenCarePointModel

    /// Retrieves detailed information for a specific Women Care Point.
    ///
    /// This method always fetches data from the remote source.
    ///
    /// - Parameter centerId: Unique identifier of the care center.
    /// - Returns: A `WomenCarePointModel` containing detailed information.
    /// - Throws: An error if data fetching or mapping fails.
    func getWomanCarePointDetailInformation(centerId: String) async throws -> WomenCarePointModel

    /// Saves home information into the local data source.
    ///
    /// - Parameter centers: Domain model containing Women Care Points home information.
    /// - Throws: An error if mapping or saving fails.
    func saveHomeDataToLocal(centers: WomenCarePointModel) async throws
}
