import Foundation

/// Shared `JSONDecoder` configured to convert snake_case keys
/// from the API response into camelCase Swift properties.
let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

/// Root data entity that represents the response structure
/// returned by the Women Care Points public API.
///
/// This entity directly mirrors the API JSON format and is intended
/// to be used in the data layer before mapping into domain models.
public class WomenCarePointDataEntity: @unchecked Sendable, Codable {

    /// Main container of events returned by the API.
    ///
    /// This property maps the `@graph` key from the JSON response.
    public let graph: [Event?]?

    /// Coding keys to map special JSON keys.
    enum CodingKeys: String, CodingKey {
        case graph = "@graph"
    }

    /// Initializes the root data entity.
    ///
    /// - Parameter graph: Array of optional `Event` objects.
    public init(graph: [Event?]?) {
        self.graph = graph
    }

    /// Represents a single event or care point entry returned by the API.
    ///
    /// This entity contains general information, location data,
    /// organizational details and recurrence rules.
    public class Event: Codable {

        /// Unique identifier of the event.
        let id: String?
        /// Unique UID provided by the API.
        let uid: String?
        /// Event start date in string format.
        let dtstart: String?
        /// Event end date in string format.
        let dtend: String?
        /// Title or name of the event or care point.
        let title: String?
        /// Detailed description.
        let description: String?
        /// External link related to the event.
        let link: String?
        /// Relation metadata provided by the API.
        let relation: String?
        /// Reference metadata.
        let references: String?
        /// Event location description as plain text.
        let eventLocation: String?
        /// Days excluded from the recurrence.
        let excludedDays: String?
        /// Price information if available.
        let price: Double?
        /// Geographic coordinates of the event.
        let location: Location?
        /// Postal address information.
        let address: Address?
        /// Organization responsible for the event.
        let organization: Organization?
        /// Recurrence rules for repeated events.
        let recurrence: Recurrence?
        /// Type metadata provided by the API.
        let type: String?
        /// Canonical URL or identifier of the event.
        let url: String?
        /// Coding keys to map special JSON fields.
        enum CodingKeys: String, CodingKey {
            case id, uid, dtstart, dtend, title, description, link, relation, references, price, location, address, organization, recurrence
            case eventLocation = "event-location"
            case excludedDays = "excluded-days"
            case type = "@type"
            case url = "@id"
        }

        /// Initializes an `Event`.
        ///
        /// - Parameters:
        ///   - id: Unique identifier of the event.
        ///   - uid: UID provided by the API.
        ///   - dtstart: Event start date.
        ///   - dtend: Event end date.
        ///   - title: Event title.
        ///   - description: Event description.
        ///   - link: Related external link.
        ///   - relation: Relation metadata.
        ///   - references: Reference metadata.
        ///   - eventLocation: Plain text event location.
        ///   - excludedDays: Days excluded from recurrence.
        ///   - price: Price information if available.
        ///   - location: Geographic coordinates.
        ///   - address: Postal address.
        ///   - organization: Organization information.
        ///   - recurrence: Recurrence rules.
        ///   - type: Event type metadata.
        ///   - url: Canonical event identifier.
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

    /// Represents geographic coordinates.
    public class Location: Codable {
        /// Latitude coordinate.
        let latitude: Double?
        /// Longitude coordinate.
        let longitude: Double?

        /// Initializes a `Location`.
        ///
        /// - Parameters:
        ///   - latitude: Latitude coordinate.
        ///   - longitude: Longitude coordinate.
        public init(latitude: Double?, longitude: Double?) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }

    /// Represents postal address information.
    public class Address: Codable {
        /// City or locality name.
        let locality: String?
        /// Postal code.
        let postalCode: String?
        /// Street name and number.
        let streetAddress: String?
        /// Administrative area information.
        let area: IDWrapper?
        /// District information.
        let district: IDWrapper?

        /// Coding keys to map JSON fields.
        enum CodingKeys: String, CodingKey {
            case locality
            case postalCode = "postal-code"
            case streetAddress = "street-address"
            case area, district
        }

        /// Initializes an `Address`.
        ///
        /// - Parameters:
        ///   - locality: City or locality name.
        ///   - postalCode: Postal code.
        ///   - streetAddress: Street name and number.
        ///   - area: Administrative area identifier.
        ///   - district: District identifier.
        public init(locality: String?,
                    postalCode: String?,
                    streetAddress: String?,
                    area: IDWrapper?,
                    district: IDWrapper?) {
            self.locality = locality
            self.postalCode = postalCode
            self.streetAddress = streetAddress
            self.area = area
            self.district = district
        }
    }

    /// Wrapper used to decode objects that only expose an `@id` field.
    public class IDWrapper: Codable {
        /// Identifier value.
        let id: String?

        /// Coding keys to map special JSON keys.
        enum CodingKeys: String, CodingKey {
            case id = "@id"
        }

        /// Initializes an `IDWrapper`.
        ///
        /// - Parameters:
        ///   - id: Identifier value.
        public init(id: String?) {
            self.id = id
        }
    }

    /// Represents organizational information related to a care point.
    public class Organization: Codable {
        /// Accessibility information.
        let accesibility: String?
        /// Services offered by the organization.
        let services: String?
        /// Opening hours or schedule.
        let schedule: String?
        /// Organization name.
        let organizationName: String?
        /// Organization description.
        let organizationDesc: String?

        /// Coding keys to map JSON fields.
        enum CodingKeys: String, CodingKey {
            case accesibility, services, schedule
            case organizationName = "organization-name"
            case organizationDesc = "organization-desc"
        }

        /// Initializes an `Organization`.
        ///
        /// - Parameters:
        ///   - accesibility: Accessibility information.
        ///   - services: Services offered.
        ///   - schedule: Opening hours or schedule.
        ///   - organizationName: Organization name.
        ///   - organizationDesc: Organization description.itializes an `Organization`.
        public init(accesibility: String?,
                    services: String?,
                    schedule: String?,
                    organizationName: String?,
                    organizationDesc: String?) {
            self.accesibility = accesibility
            self.services = services
            self.schedule = schedule
            self.organizationName = organizationName
            self.organizationDesc = organizationDesc
        }
    }

    /// Represents recurrence rules for repeated events.
    public class Recurrence: Codable {
        /// Interval between recurrences.
        let interval: Int?
        /// Days on which the event occurs.
        let days: String?
        /// Recurrence frequency (daily, weekly, etc.).
        let frequency: String?

        /// Initializes a `Recurrence`.
        ///
        /// - Parameters:
        ///   - interval: Interval between recurrences.
        ///   - days: Days on which the event occurs.
        ///   - frequency: Recurrence frequency.
        public init(interval: Int?, days: String?, frequency: String?) {
            self.interval = interval
            self.days = days
            self.frequency = frequency
        }
    }
}
