import Combine
import FDependencyInjector
import FPresentation

///
public protocol WomenCarePointHomeHeaderSectionMapperContract: SectionMapperContract {}

///
final class WomenCarePointHomeHeaderSectionMapper: WomenCarePointHomeHeaderSectionMapperContract {

    typealias RenderModel = Void
    typealias ViewModel = WomenCarePointHomeHeaderSectionViewModelContract
    typealias ObservedModel = Void
    
    @Dependency var viewModel: ViewModel
    
    func getObservedPublisher(_ viewModel: ViewModel) -> AnyPublisher<ObservedModel, Never> {
        Just(()).eraseToAnyPublisher()
    }
    
    func map(_ model: ObservedModel) -> RenderModel {
        return RenderModel()
    }
}
