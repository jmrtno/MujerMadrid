struct WomenCarePointHomeListSectionRenderModel {
    /// information from centers
    public let centers: [Centers]
    /// Boolean that show/hide centers list
    public var showList: Bool
    
    /// Initializer for `WomenCarePointHomeListSectionRenderModel`
    /// - Parameters:
    ///  - centers: information from centers
    ///  - showList: Boolean that show/hide centers list
    public init(centers: [Centers], showList: Bool) {
        self.centers = centers
        self.showList = showList
    }

    /// empty init
    init() {
        centers = []
        showList = false
    }

    struct Centers: Identifiable {
        /// Centers id
        public let id: String
        /// Centers name
        public let title: String
        /// Center saddress
        public let streetAddress: String
        /// Centers postal code
        public let postalCode: String
        /// Centesr locality
        public let locality: String
        /// Centers schedule
        public let schedule: String
        /// Centers location
        public let location: Location
        
        /// Initializer for `Centers`
        /// - Parameters:
        ///  - id: Centers id
        ///  - title: Centers name
        ///  - streetAddress: Centers address
        ///  - postalCode: Centers postal code
        ///  - locality: Centers locality
        ///  - schedule: Centers schedule
        ///  - location: Centers location
        public init(id: String,
                    title: String,
                    streetAddress: String,
                    postalCode: String,
                    locality: String,
                    schedule: String,
                    location: Location) {
            self.id = id
            self.title = title
            self.streetAddress = streetAddress
            self.postalCode = postalCode
            self.locality = locality
            self.schedule = schedule
            self.location = location
        }

        /// empty init
        init() {
            id = ""
            title = ""
            streetAddress = ""
            postalCode = ""
            locality = ""
            schedule = ""
            location = .init()
        }
    }
    
    final class Location: Codable {
        /// Centers latitude
        public let latitude: Double
        /// Centers longitude
        public let longitude: Double
        
        /// Initializer for `Location`
        /// - Parameters:
        ///  - latitude: Cente's latitude
        ///  - longitude: Centers longitude
        public init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
        
        /// empty init
        init() {
            latitude = 0.0
            longitude = 0.0
        }
    }
}
