import Combine

/// Contract for the WomenCarePointHomeListSection ViewModel
protocol WomenCarePointHomeListSectionViewModelContract {
    // MARK: - Outputs
    /// Publishes the observed model containing the list of women care points
    var womenCarePointInformationPublisher: AnyPublisher<WomenCarePointHomeListSectionObservedModel, Never> { get }

    // MARK: - Inputs
    /// Fetches the list of women care points from the repository or use case
    func getWomenCarePointInformationData()
    
    /// Navigates to the detail screen for a selected center
    func navigateToCarePointDetail(centerId: String)
}
