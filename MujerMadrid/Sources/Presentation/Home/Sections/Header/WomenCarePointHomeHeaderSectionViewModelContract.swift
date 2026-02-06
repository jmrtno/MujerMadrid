import Combine

/// Contract defining the interface for the Women Care Point Home header section view model.
protocol WomenCarePointHomeHeaderSectionViewModelContract {
// MARK: - Inputs

    /// Called when the toggle button is tapped.
    func didTapToggle()
    ///
    func filterSelected(filter: String)
}
