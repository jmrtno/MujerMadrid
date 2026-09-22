import Combine
import FDependencyInjector
import FPresentation
import Foundation
import MapKit

/// Dependencies required to initialize `WomenCarePointDetailViewModel`.
final class WomenCarePointDetailViewModelDependencies {
    /// Complete data of the Women Care Point center.
    let centerData: WomenCarePointModel.EventModel

    /// Initializes the dependencies.
    /// - Parameter centerData: Complete data of the center.
    init(centerData: WomenCarePointModel.EventModel) {
        self.centerData = centerData
    }
}

/// Maps applications available for navigation directions.
enum MapsApp {
    case appleMaps
    case googleMaps
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

    // MARK: Publishers

    /// Padding size for layout purposes.
    var paddingSize: CGFloat { get }
}

/// ViewModel for the Women Care Point detail screen.
///
/// Conforms to multiple contracts to handle content sections and header section.
final class WomenCarePointDetailViewModel: @unchecked Sendable,
                                           WomenCarePointDetailViewModelContract,
                                           WomenCarePointDetailContentSectionViewModelContract,
                                           WomenCarePointDetailHeaderSectionViewModelContract {
    // MARK: - Dependencies

    /// Center identifier used for padding/height calculations.
    private var centerId: String = ""

    /// Required initializer for dependency injection.
    required init() {
        @Injected var navigationBuilder: WomenCarePointDetailNavigationBuilderContract
        self.navigationBuilder = navigationBuilder
    }

    /// Initializes with explicit dependencies.
    /// - Parameter navigationBuilder: Navigation builder for handling navigation actions.
    init(navigationBuilder: WomenCarePointDetailNavigationBuilderContract) {
        self.navigationBuilder = navigationBuilder
    }

    // MARK: - Published Properties

    /// Published Women Care Point detail content.
    @Published var womenCarePointDetailInformationPublished: WomenCarePointDetailContentSectionObservedModel = .init()
    /// Published Women Care Point header information.
    @Published var womenCarePointCenterHeaderInfoPublished: WomenCarePointDetailHeaderSectionObservedModel = .init()

    private let locationManager = LocationManager()
    private let smallNameIds: Set<String> = ["5433767", "184260"]
    private let longNameIds: Set<String> = ["11952990", "11089192"]

    // MARK: - Publishers

    /// Publisher emitting the detail content section observed model.
    var womenCarePointDetailInformationPublisher: AnyPublisher<WomenCarePointDetailContentSectionObservedModel, Never> {
        $womenCarePointDetailInformationPublished.eraseToAnyPublisher()
    }

    /// Publisher emitting the header section observed model.
    var womenCarePointCenterHeaderInfoPublisher: AnyPublisher<WomenCarePointDetailHeaderSectionObservedModel, Never> {
        $womenCarePointCenterHeaderInfoPublished.eraseToAnyPublisher()
    }

    // MARK: - Navigation

    /// Navigation builder used to navigate between screens.
    var navigationBuilder: WomenCarePointDetailNavigationBuilderContract

    // MARK: - Inputs

    /// Called when the view appears.
    func notifyAppearance() {
        // Data is already populated via setupDependencies
    }

    /// Sets up the dependencies of the view model with the complete center data.
    /// - Parameter dependencies: Dependencies required by the view model.
    func setupDependencies(_ dependencies: WomenCarePointDetailViewModelDependencies) {
        let data = dependencies.centerData
        self.centerId = data.id ?? ""
        self.womenCarePointDetailInformationPublished = WomenCarePointDetailContentSectionObservedModel(data: [data])
        self.womenCarePointCenterHeaderInfoPublished.title = data.title ?? ""
        self.womenCarePointCenterHeaderInfoPublished.description = data.organization?.organizationDesc ?? ""
        self.womenCarePointCenterHeaderInfoPublished.services = data.organization?.services ?? ""
    }

    /// Navigates back to the previous screen.
    func goBack() {
        navigationBuilder.goBack(animated: true, screen: nil, nil)
    }

    /// Whether Google Maps is installed on the device.
    @MainActor
    var isGoogleMapsAvailable: Bool {
        guard let googleMapsURL = URL(string: "comgooglemaps://") else { return false }
        return UIApplication.shared.canOpenURL(googleMapsURL)
    }

    /// Opens the selected maps app for directions to the specified coordinates.
    /// - Parameters:
    ///   - latitud: Latitude of the destination.
    ///   - longitud: Longitude of the destination.
    ///   - app: The maps application to use for directions.
    @MainActor
    func navigateTo(latitud: Double, longitud: Double, using app: MapsApp) {
        switch app {
        case .googleMaps:
            guard let url = URL(string: "comgooglemaps://?daddr=\(latitud),\(longitud)&directionsmode=driving") else { return }
            UIApplication.shared.open(url)
        case .appleMaps:
            openDirectionsInAppleMaps(latitud: latitud, longitud: longitud)
        }
    }

    /// Opens Apple Maps for directions to the specified coordinates.
    /// - Parameters:
    ///   - latitud: Latitude of the destination.
    ///   - longitud: Longitude of the destination.
    @MainActor
    private func openDirectionsInAppleMaps(latitud: Double, longitud: Double) {
        let destinationCoordinate = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = womenCarePointCenterHeaderInfoPublished.title

        let currentLocationMapItem = MKMapItem.forCurrentLocation()
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]

        MKMapItem.openMaps(with: [currentLocationMapItem, destinationMapItem], launchOptions: options)
    }

    /// Returns the padding size depending on the center ID.
    var paddingSize: CGFloat {
        if smallNameIds.contains(centerId) {
            return 150
        } else if longNameIds.contains(centerId) {
            return 175
        } else {
            return 160
        }
    }

    /// Returns the header height depending on the center ID.
    var headerHeight: CGFloat {
        if smallNameIds.contains(centerId) {
            return 220
        } else if longNameIds.contains(centerId) {
            return 255
        } else {
            return 240
        }
    }
}
