import Combine

/// Contract defining the interface for the Women Care Point detail content section view model.
///
/// This protocol exposes publishers for the observed model and functions
/// for user-driven interactions, such as navigation.
protocol WomenCarePointDetailContentSectionViewModelContract {

    // MARK: - Outputs

    /// Publisher that emits the observed model containing detailed information
    /// about a Women Care Point.
    var womenCarePointDetailInformationPublisher: AnyPublisher<WomenCarePointDetailContentSectionObservedModel, Never> { get }

    // MARK: - Inputs

    /// Triggers navigation to the specified coordinates.
    func navigateTo(latitud: Double, longitud: Double)
}
