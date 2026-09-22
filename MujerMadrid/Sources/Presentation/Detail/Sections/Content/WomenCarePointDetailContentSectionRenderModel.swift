import MapKit

struct WomenCarePointDetailContentSectionRenderModel {
    /// information from centers
    let center: Center

    /// Initializer for `WomenCarePointDetailContentSectionRenderModel`
    /// - Parameters:
    ///  - centers: information from centers
    init(center: Center) {
        self.center = center
    }
    
    /// empty init
    init() {
        center = .init()
    }
    
    struct Center: Identifiable {
        /// Center id
        let id: String
        /// Center name
        let title: String
        /// Center description
        let description: String
        /// Center services
        let services: String
        /// Center street address
        let streetAddress: String
        /// Center postal code
        let postalCode: String
        /// Center locality
        let locality: String
        /// Center schedule
        let schedule: String
        /// Center location
        let location: Location
        
        /// Initializer for `Center`
        /// - Parameters:
        ///  - id: Center id
        ///  - title: Center name
        ///  - description: Center description
        ///  - services: Center services
        ///  - streetAddress: Center address
        ///  - postalCode: Center postal code
        ///  - locality: Center locality
        ///  - schedule: Center schedule
        ///  - location: Center location
        init(id: String,
                    title: String,
                    description: String,
                    services: String,
                    streetAddress: String,
                    postalCode: String,
                    locality: String,
                    schedule: String,
                    location: Location) {
            self.id = id
            self.title = title
            self.description = description
            self.services = services
            self.streetAddress = streetAddress
            self.postalCode = postalCode
            self.locality = locality
            self.schedule = schedule
            self.location = location
        }

        /// empty initializer
        init() {
            id = ""
            title = ""
            description = ""
            services = ""
            streetAddress = ""
            postalCode = ""
            locality = ""
            schedule = ""
            location = .init()
        }
    }
    
    struct Location: Codable {
        /// Center latitude
        let latitude: Double
        /// Center longitude
        let longitude: Double
        
        /// Initializer for `Location`
        /// - Parameters:
        ///  - latitude: Center latitude
        ///  - longitude: Center longitude
        init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }

        /// empty initializer
        init() {
            latitude = 0.0
            longitude = 0.0
        }
    }
}
