//
//  WomenCarePointModel.swift
//  MujerMadrid
//
//  Created by Javier Martin on 16/7/25.
//

import Foundation

final class WomenCarePointModel: @unchecked Sendable, Codable {
    public let data: [EventModel]
    
    public init(data: [EventModel]) {
        self.data = data
    }
    
    final class EventModel: Codable {
        let id: String?
        let uid: String?
        let dtstart: String?
        let dtend: String?
        let title: String?
        let description: String?
        let link: String?
        let relation: String?
        let references: String?
        let eventLocation: String?
        let excludedDays: String?
        let price: Double?
        let location: LocationModel?
        let address: AddressModel?
        let organization: OrganizationModel?
        let recurrence: RecurrenceModel?
        let type: String?
        let url: String? // para mapear @id
        
        public init(id: String?,
                    uid: String?,
                    dtstart: String?,
                    dtend: String?,
                    title: String?,
                    description: String?,
                    link: String?,
                    relation: String?,
                    references: String?,
                    eventLocation: String?,
                    excludedDays: String?,
                    price: Double?,
                    location: LocationModel?,
                    address: AddressModel?,
                    organization: OrganizationModel?,
                    recurrence: RecurrenceModel?,
                    type: String?,
                    url: String?) {
            self.id = id
            self.uid = uid
            self.dtstart = dtstart
            self.dtend = dtend
            self.title = title
            self.description = description
            self.link = link
            self.relation = relation
            self.references = references
            self.eventLocation = eventLocation
            self.excludedDays = excludedDays
            self.price = price
            self.location = location
            self.address = address
            self.organization = organization
            self.recurrence = recurrence
            self.type = type
            self.url = url
        }
    }
    
    final class LocationModel: Codable {
        let latitude: Double?
        let longitude: Double?
        
        public init(latitude: Double?, longitude: Double?) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }

    final class AddressModel: Codable {
        let locality: String?
        let postalCode: String?
        let streetAddress: String?
        let area: IDWrapperModel?
        let district: IDWrapperModel?
        
        public init(locality: String?, postalCode: String?, streetAddress: String?, area: IDWrapperModel?, district: IDWrapperModel?) {
            self.locality = locality
            self.postalCode = postalCode
            self.streetAddress = streetAddress
            self.area = area
            self.district = district
        }
    }
    
    final class IDWrapperModel: Codable {
        let id: String?
        
        public init(id: String?) {
            self.id = id
        }
    }

    public class OrganizationModel: Codable {
        let accesibility: String?
        let services: String?
        let schedule: String?
        let organizationName: String?
        let organizationDesc: String?
        
        public init(accesibility: String?, services: String?, schedule: String?, organizationName: String?, organizationDesc: String?) {
            self.accesibility = accesibility
            self.services = services
            self.schedule = schedule
            self.organizationName = organizationName
            self.organizationDesc = organizationDesc
        }
    }

    public class RecurrenceModel: Codable {
        let interval: Int?
        let days: String?
        let frequency: String?
        
        public init(interval: Int?, days: String?, frequency: String?) {
            self.interval = interval
            self.days = days
            self.frequency = frequency
        }
    }
}
