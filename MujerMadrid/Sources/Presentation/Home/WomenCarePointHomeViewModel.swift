import Combine
import FDependencyInjector
import Foundation
import FPresentation
import MapKit
import SwiftUI

/// Dependencies of the WomenCarePointHomeViewModel
final class WomenCarePointHomeViewModelDependencies {}

/// Contract defining the public interface of the WomenCarePointHomeViewModel
protocol WomenCarePointHomeViewModelContract: ViewModelContract {
    // MARK: Dependencies
    /// Setup the dependencies of the ViewModel
    /// - Parameter dependencies: dependencies required by the ViewModel
    func setupDependencies(_ dependencies: WomenCarePointHomeViewModelDependencies)
    
    // MARK: Inputs
    /// Called when the view appears
    func notifyAppearance()

    // MARK: Publishers
    var errorPublisher: AnyPublisher<Bool, Never> { get }
    var loaderPublisher: AnyPublisher<Bool, Never> { get }
}

/// ViewModel for the WomenCarePoint Home screen
final class WomenCarePointHomeViewModel: @unchecked Sendable,
                                         WomenCarePointHomeViewModelContract,
                                         WomenCarePointHomeListSectionViewModelContract,
                                         WomenCarePointHomeFooterSectionViewModelContract,
                                         WomenCarePointHomeHeaderSectionViewModelContract,
                                         CrossErrorSectionViewModelContract {

    // MARK: - UseCase
    /// UseCase to fetch care points information
    let getWomenCarePointUseCase: GetWomenCarePointHomeUseCaseContract
    
    /// Default initializer injected by FDependencyInjector
    public required init() {
        @Injected var useCase: GetWomenCarePointHomeUseCaseContract
        @Injected var navigationBuilder: WomenCarePointHomeNavigationBuilderContract
        self.getWomenCarePointUseCase = useCase
        self.navigationBuilder = navigationBuilder
    }
    
    /// Custom initializer for testing or manual injection
    init(useCase: GetWomenCarePointHomeUseCaseContract,
         navigationBuilder: WomenCarePointHomeNavigationBuilderContract) {
        self.getWomenCarePointUseCase = useCase
        self.navigationBuilder = navigationBuilder
    }

    // MARK: - Published Properties
    /// Observed model containing the list of care points to display in the Home screen.
    @Published public var womenCarePointInformationPublished: WomenCarePointHomeListSectionObservedModel = .init()
    /// Indicates whether the loader should be shown.
    @Published var isLoading = false
    /// Indicates whether an error occurred while fetching data.
    @Published var isError = false

    /// CLLocationManager instance used to request location permissions if needed.
    private let locationManager = CLLocationManager()

    // MARK: - Publishers
    
    /// Publisher that emits updates of the Home list section model.
    public var womenCarePointInformationPublisher: AnyPublisher<WomenCarePointHomeListSectionObservedModel, Never> {
        $womenCarePointInformationPublished.eraseToAnyPublisher()
    }

    /// Publisher that emits the loading state.
    public var loaderPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }

    /// Publisher that emits the error state.
    public var errorPublisher: AnyPublisher<Bool, Never> {
        $isError.eraseToAnyPublisher()
    }

    /// NavigationBuilder used to navigate to another screen
    public var navigationBuilder: WomenCarePointHomeNavigationBuilderContract
    
    // MARK: - Inputs
    /// Called when the view appears
    public func notifyAppearance() {
        requestLocationPermissionsIfNeeded()
        loadData()
    }
    
    /// Setup dependencies
    /// - Parameter dependencies: injected dependencies
    public func setupDependencies(_ dependencies: WomenCarePointHomeViewModelDependencies) { }
    
    /// Navigate to the detail screen of a care point
    /// - Parameter centerId: identifier of the care point
    public func navigateToCarePointDetail(centerId: String) {
        navigationBuilder.navigateToCarePointDetail(centerId: centerId)
    }
    
    /// Call a phone number
    /// - Parameter number: phone number as a string
    public func callNumber(number: String) {
        Task { @MainActor in
            if let url = URL(string: "tel://\(number)"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }

    /// Toggle between map/list view
    public func didTapToggle() {
        womenCarePointInformationPublished.showList.toggle()
    }

    /// Retry loading data after an error
    public func didTapTryAgain() {
        self.isLoading = true
        self.isError = false
        loadData()
    }
}

// MARK: - Private Methods
private extension WomenCarePointHomeViewModel {
    /// Loads care points information using the use case
    func loadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.isLoading = true
            do {
                let info = try await self.getWomenCarePointUseCase.run()
                self.womenCarePointInformationPublished.data = info.data
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.isError = true
            }
        }
    }
    
    /// Requests location permissions if not yet determined
    private func requestLocationPermissionsIfNeeded() {
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
