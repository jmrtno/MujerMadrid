import FDependencyInjector
import FNavigation

final class NavigationModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register(ScreenNavigator.self, Navigator.self)
    }
}
