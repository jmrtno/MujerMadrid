//
//  WomenCarePointDetailContentSectionRenderModel.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//
import MapKit

struct WomenCarePointDetailContentSectionRenderModel {
    /// information from centers
    public let center: Center

    /// Initializer for `WomenCarePointDetailContentSectionRenderModel`
    /// - Parameters:
    ///  - centers: information from centers
    public init(center: Center) {
        self.center = center
    }
    
    /// empty init
    init() {
        center = .init()
    }
    
    struct Center: Identifiable {
        /// Center id
        public let id: String
        /// Center name
        public let title: String
        /// Center description
        public let description: String
        /// Center services
        public let services: String
        /// Center street address
        public let streetAddress: String
        /// Center postal code
        public let postalCode: String
        /// Center locality
        public let locality: String
        /// Center schedule
        public let schedule: String
        /// Center location
        public let location: Location
        
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
        public init(id: String,
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
        public let latitude: Double
        /// Center longitude
        public let longitude: Double
        
        /// Initializer for `Location`
        /// - Parameters:
        ///  - latitude: Center latitude
        ///  - longitude: Center longitude
        public init(latitude: Double, longitude: Double) {
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
