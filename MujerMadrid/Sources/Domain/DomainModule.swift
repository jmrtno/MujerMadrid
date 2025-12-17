import FDependencyInjector

final class DomainModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register(GetWomenCarePointHomeUseCaseContract.self,
                                            GetWomenCarePointHomeUseCase.self)
        DependencyContainer.shared.register(GetWomenCarePointDetailUseCaseContract.self,
                                            GetWomenCarePointDetailUseCase.self)
    }
}
