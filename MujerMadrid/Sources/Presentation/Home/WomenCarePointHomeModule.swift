import FDependencyInjector

final class WomenCarePointHomeModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register(WomenCarePointHomeViewModelContract.self, WomenCarePointHomeViewModel.self)
        DependencyContainer.shared.register(WomenCarePointHomeNavigationBuilderContract.self, WomenCarePointHomeNavigationBuilder.self)
    }
}
