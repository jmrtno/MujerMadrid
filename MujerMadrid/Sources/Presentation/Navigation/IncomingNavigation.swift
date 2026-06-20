import Foundation
import FNavigation

/// Enum defining the possible navigation targets in the MujerMadrid app.
/// Conforms to `NavigationInfo` to integrate with the navigation system.
enum IncomingNavigation: NavigationInfo {
    /// Navigate to the Home screen
    case home
    
    /// Navigate to the Detail screen for a specific care point
    /// - Parameter centerData: Complete data of the care point to display
    case detail(centerData: WomenCarePointModel.EventModel)

    /// Defines how each navigation case should be presented
    var presentationType: PresentationType {
        switch self {
        case .home:
            return .goToRoot
        case .detail:
            return .push
        }
    }
}
