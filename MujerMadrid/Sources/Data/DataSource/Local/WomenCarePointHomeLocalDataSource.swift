import FDependencyInjector
import Foundation

/// Contract that defines the local data source responsible for storing
/// and retrieving Women Care Points home information.
///
/// This data source is actor-isolated to ensure thread-safe access
/// in concurrent environments.
public protocol WomenCarePointHomeLocalDataSourceContract: Actor, Sendable, Instanciable {

    /// Retrieves the locally cached home information for Women Care Points.
    ///
    /// - Returns: A `WomenCarePointDataEntity` if available, or `nil` if no data is cached.
    func getLocalHomeInformation() -> WomenCarePointDataEntity?

    /// Stores the home information locally.
    ///
    /// - Parameter entity: The `WomenCarePointDataEntity` to be cached.
    func setLocalHomeInformation(entity: WomenCarePointDataEntity)
}

/// Default implementation of `WomenCarePointHomeLocalDataSourceContract`.
///
/// This actor acts as an in-memory cache for the Women Care Points home information,
/// providing safe access across multiple concurrent contexts.
public actor WomenCarePointHomeLocalDataSource: @unchecked Sendable, WomenCarePointHomeLocalDataSourceContract {

    /// Cached home information stored in memory.
    private var informationLocalDataSource: WomenCarePointDataEntity?

    /// Initializes the local data source.
    public init() { }

    /// Returns the locally stored home information, if any.
    ///
    /// - Returns: A `WomenCarePointDataEntity` if cached, otherwise `nil`.
    public func getLocalHomeInformation() -> WomenCarePointDataEntity? {
        return informationLocalDataSource
    }

    /// Updates the locally stored home information.
    ///
    /// - Parameter entity: The `WomenCarePointDataEntity` to store.
    public func setLocalHomeInformation(entity: WomenCarePointDataEntity) {
        self.informationLocalDataSource = entity
    }
}
