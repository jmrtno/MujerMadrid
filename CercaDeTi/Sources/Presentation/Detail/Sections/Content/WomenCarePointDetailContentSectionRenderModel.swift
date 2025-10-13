//
//  WomenCarePointDetailContentRenderModel.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//
import MapKit

public struct WomenCarePointDetailContentSectionRenderModel {
    
    public let center: Center
    
    public init(center: Center) {
        self.center = center
    }

    init() {
        center = .init()
    }
    
    public struct Center: Identifiable {
        public var id: String
        public let title: String
        public let description: String
        public let services: String
        public let streetAddress: String
        public let postalCode: String
        public let locality: String
        public let schedule: String
        public let location: Location
        
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
    
    open class Location: Codable {
        let latitude: Double
        let longitude: Double
        
        public init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }

        init() {
            latitude = 0.0
            longitude = 0.0
        }
    }
}
