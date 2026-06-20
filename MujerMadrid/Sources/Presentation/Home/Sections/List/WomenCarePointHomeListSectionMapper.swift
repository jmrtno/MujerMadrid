import Combine
import FDependencyInjector
import FPresentation

/// Contract defining the interface for mapping the Women Care Point Home list section.
public protocol WomenCarePointHomeListSectionMapperContract: SectionMapperContract {}

/// Mapper for the Women Care Point Home list section.
/// Responsible for converting the observed model from the view model into a render model suitable for the view.
final class WomenCarePointHomeListSectionMapper: WomenCarePointHomeListSectionMapperContract {
    typealias RenderModel = WomenCarePointHomeListSectionRenderModel
    typealias ViewModel = WomenCarePointHomeListSectionViewModelContract
    typealias ObservedModel = WomenCarePointHomeListSectionObservedModel
    
    @Dependency var viewModel: ViewModel
    
    /// Returns the observed publisher from the view model.
    /// - Parameter viewModel: The view model providing the observed data.
    /// - Returns: A publisher emitting the observed model.
    func getObservedPublisher(_ viewModel: ViewModel) -> AnyPublisher<ObservedModel, Never> {
        viewModel.womenCarePointInformationPublisher
    }
    
    /// Maps the observed model to a render model.
    /// - Parameter model: The observed model from the view model.
    /// - Returns: A render model to be used by the view.
    func map(_ model: ObservedModel) -> RenderModel {
        toRenderModel(model: model)
    }
}

private extension WomenCarePointHomeListSectionMapper {
    /// Converts the observed model into a render model.
    /// - Parameter model: The observed model containing data about centers.
    /// - Returns: A render model containing formatted center data and visibility flag.
    func toRenderModel(model: WomenCarePointHomeListSectionObservedModel) -> WomenCarePointHomeListSectionRenderModel {
        let centers: [WomenCarePointHomeListSectionRenderModel.Centers] = model.data?.compactMap { data in
            WomenCarePointHomeListSectionRenderModel.Centers(
                id: data.id ?? "",
                title: data.title ?? "",
                streetAddress: Utils().formatStreetAddress(data.address?.streetAddress),
                postalCode: data.address?.postalCode ?? "",
                locality: Utils().formatLocality(data.address?.locality),
                schedule: data.organization?.schedule ?? "",
                location: WomenCarePointHomeListSectionRenderModel.Location(
                    latitude: data.location?.latitude ?? 0.0,
                    longitude: data.location?.longitude ?? 0.0
                ),
                eventData: data
            )
        } ?? []
        return WomenCarePointHomeListSectionRenderModel(centers: centers, showList: model.showList)
    }
}
