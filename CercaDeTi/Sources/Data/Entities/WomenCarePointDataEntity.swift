//
//  WomenCarePointDataEntity.swift
//  MujerMadrid
//
//  Created by Javier Martin on 16/7/25.
//

import Foundation

let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

public class WomenCarePointDataEntity: @unchecked Sendable, Codable {
    public let graph: [Event?]?

    enum CodingKeys: String, CodingKey {
        case graph = "@graph"
    }
    
    public init(graph: [Event?]?) {
        self.graph = graph
    }
    
    public class Event: Codable {
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
        let location: Location?
        let address: Address?
        let organization: Organization?
        let recurrence: Recurrence?
        let type: String?
        let url: String? // para mapear @id

        enum CodingKeys: String, CodingKey {
            case id, uid, dtstart, dtend, title, description, link, relation, references, price, location, address, organization, recurrence
            case eventLocation = "event-location"
            case excludedDays = "excluded-days"
            case type = "@type"
            case url = "@id"
        }
        
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
                    location: Location?,
                    address: Address?,
                    organization: Organization?,
                    recurrence: Recurrence?,
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
    
    public class Location: Codable {
        let latitude: Double?
        let longitude: Double?
        
        public init(latitude: Double?, longitude: Double?) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }

    public class Address: Codable {
        let locality: String?
        let postalCode: String?
        let streetAddress: String?
        let area: IDWrapper?
        let district: IDWrapper?

        enum CodingKeys: String, CodingKey {
            case locality
            case postalCode = "postal-code"
            case streetAddress = "street-address"
            case area, district
        }
        
        public init(locality: String?, postalCode: String?, streetAddress: String?, area: IDWrapper?, district: IDWrapper?) {
            self.locality = locality
            self.postalCode = postalCode
            self.streetAddress = streetAddress
            self.area = area
            self.district = district
        }
    }
    
    // Para claves como "area" o "district" que contienen un @id
    public class IDWrapper: Codable {
        let id: String?

        enum CodingKeys: String, CodingKey {
            case id = "@id"
        }
        
        public init(id: String?) {
            self.id = id
        }
    }

    public class Organization: Codable {
        let accesibility: String?
        let services: String?
        let schedule: String?
        let organizationName: String?
        let organizationDesc: String?

        enum CodingKeys: String, CodingKey {
            case accesibility, services, schedule
            case organizationName = "organization-name"
            case organizationDesc = "organization-desc"
        }
        
        public init(accesibility: String?, services: String?, schedule: String?, organizationName: String?, organizationDesc: String?) {
            self.accesibility = accesibility
            self.services = services
            self.schedule = schedule
            self.organizationName = organizationName
            self.organizationDesc = organizationDesc
        }
    }

    public class Recurrence: Codable {
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
