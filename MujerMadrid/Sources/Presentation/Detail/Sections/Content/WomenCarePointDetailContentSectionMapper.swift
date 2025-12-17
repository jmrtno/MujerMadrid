import Combine
import FDependencyInjector
import FPresentation

/// Contract defining the interface for mapping Women Care Point detail content sections.
public protocol WomenCarePointDetailContentSectionMapperContract: SectionMapperContract {}

/// Mapper responsible for converting observed models into render models
/// for the Women Care Point detail content section.
final class WomenCarePointDetailContentSectionMapper: WomenCarePointDetailContentSectionMapperContract {

    typealias RenderModel = WomenCarePointDetailContentSectionRenderModel
    typealias ViewModel = WomenCarePointDetailContentSectionViewModelContract
    typealias ObservedModel = WomenCarePointDetailContentSectionObservedModel

    /// Dependency-injected view model used as the source of observed data.
    @Dependency var viewModel: ViewModel

    /// Returns a publisher of the observed model from the view model.
    ///
    /// - Parameter viewModel: The view model providing the data publisher.
    /// - Returns: A publisher emitting `ObservedModel` values.
    func getObservedPublisher(_ viewModel: ViewModel) -> AnyPublisher<ObservedModel, Never> {
        viewModel.womenCarePointDetailInformationPublisher
    }

    /// Maps an observed model into a render model suitable for the UI.
    ///
    /// - Parameter model: The observed model containing Women Care Point data.
    /// - Returns: A `RenderModel` ready for rendering.
    func map(_ model: ObservedModel) -> RenderModel {
        toRenderModel(model: model)
    }
}

// MARK: - Private Helpers
private extension WomenCarePointDetailContentSectionMapper {

    /// Converts the observed model into a render model.
    ///
    /// - Parameter model: The observed model to be converted.
    /// - Returns: A `RenderModel` representing the first care point in the data, or an empty model if none is available.
    func toRenderModel(model: WomenCarePointDetailContentSectionObservedModel) -> WomenCarePointDetailContentSectionRenderModel {
        guard let data = model.data?.first else {
            return WomenCarePointDetailContentSectionRenderModel()
        }

        let center = WomenCarePointDetailContentSectionRenderModel.Center(
            id: data.id ?? "",
            title: data.title ?? "",
            description: Utils().normalized(data.organization?.organizationDesc ?? ""),
            services: Utils().normalized(data.organization?.services ?? ""),
            streetAddress: Utils().formatStreetAddress(data.address?.streetAddress),
            postalCode: data.address?.postalCode ?? "",
            locality: Utils().formatLocality(data.address?.locality),
            schedule: data.organization?.schedule ?? "",
            location: WomenCarePointDetailContentSectionRenderModel.Location(
                latitude: data.location?.latitude ?? 0.0,
                longitude: data.location?.longitude ?? 0.0
            )
        )

        return WomenCarePointDetailContentSectionRenderModel(center: center)
    }
}
