import FDependencyInjector

final class WomenCarePointDetailModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register(WomenCarePointDetailViewModelContract.self, WomenCarePointDetailViewModel.self)
        DependencyContainer.shared.register(WomenCarePointDetailNavigationBuilderContract.self, WomenCarePointDetailNavigationBuilder.self)
    }
}
