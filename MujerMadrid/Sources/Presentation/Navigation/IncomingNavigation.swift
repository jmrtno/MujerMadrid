import Foundation
import FNavigation

/// Enum defining the possible navigation targets in the MujerMadrid app.
/// Conforms to `NavigationInfo` to integrate with the navigation system.
public enum IncomingNavigation: NavigationInfo {
    /// Navigate to the Home screen
    case home
    
    /// Navigate to the Detail screen for a specific care point
    /// - Parameter centerId: Identifier of the care point to display
    case detail(centerId: String)

    /// Defines how each navigation case should be presented
    public var presentationType: PresentationType {
        switch self {
        case .home:
            return .goToRoot
        case .detail:
            return .push
        }
    }
}
