import Combine

/// Contract defining the interface for the Women Care Point Home footer section view model.
public protocol WomenCarePointHomeFooterSectionViewModelContract {
    // MARK: - Inputs

    /// Called when a phone number should be called.
    func callNumber(number: String)
}
