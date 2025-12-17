import Combine
import FDependencyInjector
import FPresentation

/// Contract defining the interface for mapping the Women Care Point detail header section.
public protocol WomenCarePointDetailHeaderSectionMapperContract: SectionMapperContract {}

/// Mapper responsible for converting observed header models into render models
/// for the Women Care Point detail header section.
final class WomenCarePointDetailHeaderSectionMapper: WomenCarePointDetailHeaderSectionMapperContract {

    typealias RenderModel = WomenCarePointDetailHeaderSectionRenderModel
    typealias ViewModel = WomenCarePointDetailHeaderSectionViewModelContract
    typealias ObservedModel = WomenCarePointDetailHeaderSectionObservedModel

    /// Dependency-injected view model used as the source of observed data.
    @Dependency var viewModel: ViewModel

    /// Returns a publisher of the observed header model from the view model.
    ///
    /// - Parameter viewModel: The view model providing the data publisher.
    /// - Returns: A publisher emitting `ObservedModel` values.
    func getObservedPublisher(_ viewModel: ViewModel) -> AnyPublisher<ObservedModel, Never> {
        viewModel.womenCarePointCenterHeaderInfoPublisher
    }

    /// Maps an observed header model into a render model suitable for the UI.
    ///
    /// - Parameter model: The observed header model containing title, description, and services.
    /// - Returns: A `RenderModel` ready for rendering.
    func map(_ model: ObservedModel) -> RenderModel {
        let title = model.title.split(whereSeparator: { $0 == "." || $0 == "(" })
            .first
            .map(String.init) ?? ""
        let description = model.description
        let services = model.services
        return RenderModel(title: title,
                           centerType: getCenterType(description: description,
                                                     services: services))
    }
}

// MARK: - Private Helpers
private extension WomenCarePointDetailHeaderSectionMapper {

    /// Determines the center type based on keywords in the description and services.
    ///
    /// - Parameters:
    ///   - description: Description text of the center.
    ///   - services: Services text of the center.
    /// - Returns: A readable string representing the type(s) of attention provided by the center.
    func getCenterType(description: String, services: String) -> String {
        /// Define fixed order and readable text
        let orderedTypes: [(key: String, value: String)] = [
            ("psicol", "psicológica"),
            ("social", "social"),
            ("jur", "jurídica"),
            ("profes", "desarrollo profesional")
        ]

        /// Search matches respecting the order
        let foundTypes = orderedTypes.compactMap { key, value in
            (description.localizedCaseInsensitiveContains(key) ||
             services.localizedCaseInsensitiveContains(key)) ? value : nil
        }

        /// Compose the final text
        switch foundTypes.count {
        case 0:
            return "Centro de ayuda"
        case 1:
            return "Atención \(foundTypes[0])"
        case 2:
            return "Atención \(foundTypes[0]) y \(foundTypes[1])"
        default:
            let allButLast = foundTypes.dropLast().joined(separator: ", ")
            let last = foundTypes.last!
            return "Atención \(allButLast) y \(last)"
        }
    }
}
