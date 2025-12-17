import FDependencyInjector

final class WomenCarePointDetailHeaderSectionModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register((any WomenCarePointDetailHeaderSectionMapperContract).self,
                                            WomenCarePointDetailHeaderSectionMapper.self)
    }
}
