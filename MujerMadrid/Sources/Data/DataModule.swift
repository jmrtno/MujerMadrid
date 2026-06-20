import FDependencyInjector

final class DataModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register((any WomenCarePointRepositoryContract).self,
                                            WomenCarePointRepository.self)
        DependencyContainer.shared.register((any WomenCarePointHomeRemoteDataSourceContract).self,
                                            WomenCarePointHomeRemoteDataSource.self)
        DependencyContainer.shared.register((any WomenCarePointHomeLocalDataSourceContract).self,
                                            WomenCarePointHomeLocalDataSource.self)
        DependencyContainer.shared.register((any WomenCarePointMapperContract).self,
                                            WomenCarePointMapper.self)
        DependencyContainer.shared.register((any WomenCarePointAPIContract).self,
                                            WomenCarePointAPI.self)
    }
}
