//
//  WomenCarePointHomeListRenderModel.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

public struct WomenCarePointHomeListSectionRenderModel {
    
    public let centers: [Centers]
    public var showList: Bool
    
    public init(centers: [Centers], showList: Bool) {
        self.centers = centers
        self.showList = showList
    }
    
    public struct Centers: Identifiable {
        public var id: String
        public let title: String
        public let streetAddress: String
        public let postalCode: String
        public let locality: String
        public let schedule: String
        public let location: Location
        
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
    }
    
    open class Location: Codable {
        let latitude: Double
        let longitude: Double
        
        public init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }

    static var empty: WomenCarePointHomeListSectionRenderModel {
        return WomenCarePointHomeListSectionRenderModel(
            centers: [WomenCarePointHomeListSectionRenderModel.Centers(id: "",
                                                                       title: "",
                                                                       streetAddress: "",
                                                                       postalCode: "",
                                                                       locality: "",
                                                                       schedule: "",
                                                                       location: Location(latitude: 0.0,
                                                                                          longitude: 0.0))],
            showList: false)
    }
}
