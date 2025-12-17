import Combine

/// Contract that defines the interface for a CrossErrorSection view model.
///
/// This protocol exposes inputs that the view model can respond to, typically
/// from user interactions in the UI.
public protocol CrossErrorSectionViewModelContract {

    // MARK: - Inputs

    /// Called when the user taps the "Try Again" button.
    func didTapTryAgain()
}

