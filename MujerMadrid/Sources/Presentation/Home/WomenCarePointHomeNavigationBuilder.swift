import FDependencyInjector
import FPresentation
import FNavigation
import UIKit

/// Contract defining the navigation actions for the WomenCarePoint Home screen
protocol WomenCarePointHomeNavigationBuilderContract: NavigationBuilder {
    /// Navigate to the detail screen of a care point
    /// - Parameter centerId: Identifier of the care point
    func navigateToCarePointDetail(centerId: String)
}

/// Navigation builder implementation for WomenCarePoint Home
final class WomenCarePointHomeNavigationBuilder: WomenCarePointHomeNavigationBuilderContract {
    /// Default initializer required by the dependency injector
    public required init() { /* Required by injector */ }
    
    /// Navigate to the detail screen of a care point
    /// - Parameter centerId: Identifier of the care point
    public func navigateToCarePointDetail(centerId: String) {
        Router.shared.navigateTo(IncomingNavigation.detail(centerId: centerId), animated: true)
    }
    
    /// Go back to the previous screen
    /// - Parameters:
    ///   - animated: Whether the transition should be animated
    ///   - screen: Optional screen info (not used here)
    ///   - completion: Optional completion block executed after navigation
    public func goBack(animated: Bool, screen: (any NavigationInfo)?, _ completion: (() -> Void)?) {
        Router.shared.goBack(animated: true, completion: completion)
    }
}
