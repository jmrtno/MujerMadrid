import FDependencyInjector
import FPresentation
import FNavigation
import UIKit

/// Contract defining the interface for building navigation actions
/// related to the Women Care Point detail screen.
protocol WomenCarePointDetailNavigationBuilderContract: NavigationBuilder {}

/// Navigation builder responsible for handling navigation actions
/// for the Women Care Point detail screen.
final class WomenCarePointDetailNavigationBuilder: WomenCarePointDetailNavigationBuilderContract {

    /// Required initializer for dependency injection.
    public required init() { /* Required by injector */ }

    /// Performs the action to navigate back from the current screen.
    ///
    /// - Parameters:
    ///   - animated: Boolean indicating whether the transition should be animated.
    ///   - screen: Optional `NavigationInfo` representing the screen to navigate back to.
    ///   - completion: Optional closure to execute after navigation completes.
    public func goBack(animated: Bool, screen: (any NavigationInfo)?, _ completion: (() -> Void)?) {
        Router.shared.goBack(animated: true, completion: completion)
    }
}
