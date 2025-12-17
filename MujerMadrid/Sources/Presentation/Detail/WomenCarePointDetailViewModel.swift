import Combine
import FDependencyInjector
import FPresentation
import Foundation
import MapKit

/// Dependencies required to initialize `WomenCarePointDetailViewModel`.
final class WomenCarePointDetailViewModelDependencies {
    /// Identifier of the Women Care Point center.
    public let centerId: String

    /// Initializes the dependencies.
    /// - Parameter centerId: Identifier of the center.
    public init(centerId: String) {
        self.centerId = centerId
    }
}

/// Contract defining the interface for the `WomenCarePointDetailViewModel`.
protocol WomenCarePointDetailViewModelContract: ViewModelContract {
    // MARK: Dependencies

    /// Sets up the dependencies of the view model.
    /// - Parameter dependencies: Dependencies required by the view model.
    func setupDependencies(_ dependencies: WomenCarePointDetailViewModelDependencies)

    // MARK: Inputs

    /// Called when the view appears.
    func notifyAppearance()

    /// Triggers fetching of Women Care Point detail data.
    func getWomenCarePointDetailData()

    // MARK: Publishers

    /// Publisher emitting `true` when an error occurs.
    var errorPublisher: AnyPublisher<Bool, Never> { get }

    /// Publisher emitting `true` when loading data.
    var loaderPublisher: AnyPublisher<Bool, Never> { get }

    /// Padding size for layout purposes.
    var paddingSize: CGFloat { get }
}

/// ViewModel for the Women Care Point detail screen.
///
/// Conforms to multiple contracts to handle content sections, header section, and error handling.
final class WomenCarePointDetailViewModel: @unchecked Sendable,
                                           WomenCarePointDetailViewModelContract,
                                           WomenCarePointDetailContentSectionViewModelContract,
                                           WomenCarePointDetailHeaderSectionViewModelContract,
                                           CrossErrorSectionViewModelContract {
    // MARK: - Dependencies

    /// Injected center identifier.
    @Dependency public var centerId: String

    // MARK: - Use Case

    /// Use case for fetching Women Care Point detail data.
    let getWomenCarePointUseCase: GetWomenCarePointDetailUseCaseContract

    /// Required initializer for dependency injection.
    public required init() {
        @Injected var useCase: GetWomenCarePointDetailUseCaseContract
        @Injected var navigationBuilder: WomenCarePointDetailNavigationBuilderContract
        self.getWomenCarePointUseCase = useCase
        self.navigationBuilder = navigationBuilder
    }

    /// Initializes with explicit dependencies.
    /// - Parameters:
    ///   - useCase: Use case for fetching detail data.
    ///   - navigationBuilder: Navigation builder for handling navigation actions.
    init(useCase: GetWomenCarePointDetailUseCaseContract,
         navigationBuilder: WomenCarePointDetailNavigationBuilderContract) {
        self.getWomenCarePointUseCase = useCase
        self.navigationBuilder = navigationBuilder
    }

    // MARK: - Published Properties

    /// Published Women Care Point detail content.
    @Published public var womenCarePointDetailInformationPublished: WomenCarePointDetailContentSectionObservedModel = .init()
    /// Published Women Care Point header information.
    @Published public var womenCarePointCenterHeaderInfoPublished: WomenCarePointDetailHeaderSectionObservedModel = .init()
    /// Loading state.
    @Published var isLoading = false
    /// Error state.
    @Published var isError = false

    private let locationManager = LocationManager()
    private let smallNameIds: Set<String> = ["5433767", "184260"]
    private let longNameIds: Set<String> = ["11952990", "11089192"]

    // MARK: - Publishers

    /// Publisher emitting the detail content section observed model.
    public var womenCarePointDetailInformationPublisher: AnyPublisher<WomenCarePointDetailContentSectionObservedModel, Never> {
        $womenCarePointDetailInformationPublished.eraseToAnyPublisher()
    }

    /// Publisher emitting the header section observed model.
    public var womenCarePointCenterHeaderInfoPublisher: AnyPublisher<WomenCarePointDetailHeaderSectionObservedModel, Never> {
        $womenCarePointCenterHeaderInfoPublished.eraseToAnyPublisher()
    }

    /// Publisher emitting the loading state.
    public var loaderPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }

    /// Publisher emitting the error state.
    public var errorPublisher: AnyPublisher<Bool, Never> {
        $isError.eraseToAnyPublisher()
    }

    // MARK: - Navigation

    /// Navigation builder used to navigate between screens.
    public var navigationBuilder: WomenCarePointDetailNavigationBuilderContract

    // MARK: - Inputs

    /// Called when the view appears to fetch initial data.
    public func notifyAppearance() {
        getWomenCarePointDetailData()
    }

    /// Sets up the dependencies of the view model.
    /// - Parameter dependencies: Dependencies required by the view model.
    public func setupDependencies(_ dependencies: WomenCarePointDetailViewModelDependencies) {
        self.centerId = dependencies.centerId
    }

    /// Fetches initial data for the current center.
    public func getWomenCarePointDetailData() {
        loadData(for: centerId)
    }

    /// Navigates back to the previous screen.
    public func goBack() {
        navigationBuilder.goBack(animated: true, screen: nil, nil)
    }

    /// Opens Apple Maps for directions to the specified coordinates.
    /// - Parameters:
    ///   - latitud: Latitude of the destination.
    ///   - longitud: Longitude of the destination.
    public func navigateTo(latitud: Double, longitud: Double) {
        let destinationCoordinate = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = womenCarePointCenterHeaderInfoPublished.title

        let currentLocationMapItem = MKMapItem.forCurrentLocation()
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]

        MKMapItem.openMaps(with: [currentLocationMapItem, destinationMapItem], launchOptions: options)
    }

    /// Returns the padding size depending on the center ID.
    public var paddingSize: CGFloat {
        if smallNameIds.contains(centerId) {
            return 150
        } else if longNameIds.contains(centerId) {
            return 175
        } else {
            return 160
        }
    }

    /// Returns the header height depending on the center ID.
    public var headerHeight: CGFloat {
        if smallNameIds.contains(centerId) {
            return 220
        } else if longNameIds.contains(centerId) {
            return 255
        } else {
            return 240
        }
    }

    /// Called when the "Try Again" button is tapped.
    public func didTapTryAgain() {
        self.isLoading = true
        self.isError = false
        loadData(for: centerId)
    }
}

// MARK: - Private Helpers

private extension WomenCarePointDetailViewModel {

    /// Loads Women Care Point data asynchronously.
    /// - Parameter id: Identifier of the center.
    func loadData(for id: String) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.isLoading = true
            do {
                let useCase = self.getWomenCarePointUseCase
                let params = GetWomenCarePointDetailParameters(centerId: self.centerId)
                let info = try await useCase.run(params)

                self.womenCarePointDetailInformationPublished = WomenCarePointDetailContentSectionObservedModel(data: info.data)
                self.womenCarePointCenterHeaderInfoPublished.title = info.data.first?.title ?? ""
                self.womenCarePointCenterHeaderInfoPublished.description = info.data.first?.organization?.organizationDesc ?? ""
                self.womenCarePointCenterHeaderInfoPublished.services = info.data.first?.organization?.services ?? ""

                self.isError = false
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.isError = true

                let nsError = error as NSError
                print("🔴 ERROR EN DETAIL:")
                print("• Domain:", nsError.domain)
                print("• Code:", nsError.code)
                print("• Description:", nsError.localizedDescription)
                print("• UserInfo:", nsError.userInfo)

                if let response = nsError.userInfo["NSErrorFailingURLResponseKey"] as? HTTPURLResponse {
                    print("🌐 HTTP Status:", response.statusCode)
                }

                if let data = nsError.userInfo["NSErrorFailingURLResponseDataKey"] as? Data,
                   let body = String(data: data, encoding: .utf8) {
                    print("📦 Response Body:\n", body)
                }
            }
        }
    }
}
