import Foundation
import FNavigation
import SwiftUI

/// Central navigator that resolves `NavigationInfo` into SwiftUI views.
/// Conforms to `ScreenNavigator` to be used by `Router`.
final class Navigator: @unchecked Sendable, ScreenNavigator {
    
    /// Required initializer
    public required init() {}
    
    /// Resolves a `NavigationInfo` into a SwiftUI destination view
    /// - Parameter navigationInfo: The navigation info to resolve
    /// - Throws: If the navigation info cannot be handled
    /// - Returns: An optional SwiftUI view corresponding to the navigation info
    public func destinationFor(navigationInfo: NavigationInfo) throws -> (any View)? {
        // Ensure the navigation info is of type IncomingNavigation
        guard let navigation = navigationInfo as? IncomingNavigation else {
            return nil
        }
        return try handleDestinationFor(navigationInfo: navigation)
    }
    
    /// Internal handler to build the SwiftUI view for a given `IncomingNavigation` case
    /// Runs on the main actor because SwiftUI views should be created on the main thread
    /// - Parameter navigationInfo: The navigation case to handle
    /// - Throws: If the navigation info cannot be handled
    /// - Returns: A SwiftUI view corresponding to the navigation case
    @MainActor
    private func handleDestinationFor(navigationInfo: IncomingNavigation) throws -> (any View)? {
        switch navigationInfo {
        case .home:
            return WomenCarePointHomeBuilder()
                .build()

        case let .detail(centerData):
            return WomenCarePointDetailBuilder()
                .setCenterData(centerData)
                .build()
        }
    }
}
