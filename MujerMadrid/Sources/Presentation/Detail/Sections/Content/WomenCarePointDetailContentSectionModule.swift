import FDependencyInjector

final class WomenCarePointDetailContentSectionModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register((any WomenCarePointDetailContentSectionMapperContract).self,
                                            WomenCarePointDetailContentSectionMapper.self)
    }
}
