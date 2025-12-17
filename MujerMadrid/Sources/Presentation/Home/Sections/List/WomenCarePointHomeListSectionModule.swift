import FDependencyInjector

final class WomenCarePointHomeListSectionModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register((any WomenCarePointHomeListSectionMapperContract).self,
                                            WomenCarePointHomeListSectionMapper.self)
    }
}
