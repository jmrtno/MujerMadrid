import CoreLocation

/// Simple wrapper around `CLLocationManager` to request the user's location
/// and provide it via a closure.
final class LocationManager: NSObject, CLLocationManagerDelegate {
    /// The underlying CLLocationManager instance
    private let manager = CLLocationManager()
    /// Closure to return the location asynchronously
    private var locationHandler: ((CLLocationCoordinate2D?) -> Void)?

    /// Initializer sets up the CLLocationManager and its delegate
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    /// Requests the user's current location.
    /// - Parameter completion: Closure called with the user's coordinate, or nil if unavailable
    func requestLocation(_ completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        locationHandler = completion
        // Request permission to access location while app is in use
        manager.requestWhenInUseAuthorization()
        // Request a single location update
        manager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate

    /// Called when the location manager has new location data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Return the first location's coordinate
        locationHandler?(locations.first?.coordinate)
        locationHandler = nil
    }

    /// Called when the location manager fails to get a location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting user location: \(error)")
        locationHandler?(nil)
        locationHandler = nil
    }
}
