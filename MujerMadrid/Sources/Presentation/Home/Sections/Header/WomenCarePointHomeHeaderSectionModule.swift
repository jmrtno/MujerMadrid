import FDependencyInjector

final class WomenCarePointHomeHeaderSectionModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register((any WomenCarePointHomeHeaderSectionMapperContract).self,
                                            WomenCarePointHomeHeaderSectionMapper.self)
    }
}
