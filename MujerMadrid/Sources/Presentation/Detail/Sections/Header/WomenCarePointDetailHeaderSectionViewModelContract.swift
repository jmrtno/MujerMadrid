import Combine
import Foundation

/// Contract defining the interface for the Women Care Point detail header section view model.
///
/// This protocol exposes publishers for the observed header data, provides header layout
/// information, and defines input actions such as navigating back.
protocol WomenCarePointDetailHeaderSectionViewModelContract {

    // MARK: - Outputs

    /// Publisher that emits the observed model containing header information
    /// of a Women Care Point center.
    var womenCarePointCenterHeaderInfoPublisher: AnyPublisher<WomenCarePointDetailHeaderSectionObservedModel, Never> { get }
    /// The height of the header view, used for layout purposes.
    var headerHeight: CGFloat { get }

    // MARK: - Inputs
    ///
    /// Triggers the action to go back to the previous screen or context.
    func goBack()
}
