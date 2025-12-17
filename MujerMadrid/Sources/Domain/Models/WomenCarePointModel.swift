import Foundation

/// Domain model that represents Women Care Points information.
///
/// This model is used by the domain and presentation layers and
/// is independent from the API response structure.
final class WomenCarePointModel: @unchecked Sendable, Codable {

    /// Collection of care point events.
    public let data: [EventModel]

    /// Initializes the model with a list of events.
    ///
    /// - Parameters:
    ///   - data: Array of `EventModel` representing care points.
    public init(data: [EventModel]) {
        self.data = data
    }

    /// Domain representation of a single care point event.
    final class EventModel: Codable {

        /// Unique identifier of the event.
        let id: String?
        /// UID provided by the data source.
        let uid: String?
        /// Event start date.
        let dtstart: String?
        /// Event end date.
        let dtend: String?
        /// Event title.
        let title: String?
        /// Event description.
        let description: String?
        /// Related external link.
        let link: String?
        /// Relation metadata.
        let relation: String?
        /// Reference metadata.
        let references: String?
        /// Event location description.
        let eventLocation: String?
        /// Days excluded from recurrence.
        let excludedDays: String?
        /// Price information if available.
        let price: Double?
        /// Geographic coordinates.
        let location: LocationModel?
        /// Postal address information.
        let address: AddressModel?
        /// Organization responsible for the care point.
        let organization: OrganizationModel?
        /// Recurrence rules.
        let recurrence: RecurrenceModel?
        /// Type metadata.
        let type: String?
        /// Canonical identifier or URL.
        let url: String?

        /// Initializes an `EventModel`.
        ///
        /// - Parameters:
        ///   - id: Unique identifier of the event.
        ///   - uid: UID provided by the data source.
        ///   - dtstart: Event start date.
        ///   - dtend: Event end date.
        ///   - title: Event title.
        ///   - description: Event description.
        ///   - link: Related external link.
        ///   - relation: Relation metadata.
        ///   - references: Reference metadata.
        ///   - eventLocation: Event location description.
        ///   - excludedDays: Days excluded from recurrence.
        ///   - price: Price information.
        ///   - location: Geographic coordinates.
        ///   - address: Postal address.
        ///   - organization: Organization information.
        ///   - recurrence: Recurrence rules.
        ///   - type: Type metadata.
        ///   - url: Canonical identifier or URL.
        public init(
            id: String?,
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
            url: String?
        ) {
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

    /// Domain representation of geographic coordinates.
    final class LocationModel: Codable {

        /// Latitude coordinate.
        let latitude: Double?
        /// Longitude coordinate.
        let longitude: Double?

        /// Initializes a `LocationModel`.
        ///
        /// - Parameters:
        ///   - latitude: Latitude coordinate.
        ///   - longitude: Longitude coordinate.
        public init(latitude: Double?, longitude: Double?) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }

    /// Domain representation of postal address information.
    final class AddressModel: Codable {

        /// City or locality name.
        let locality: String?
        /// Postal code.
        let postalCode: String?
        /// Street name and number.
        let streetAddress: String?
        /// Administrative area identifier.
        let area: IDWrapperModel?
        /// District identifier.
        let district: IDWrapperModel?

        /// Initializes an `AddressModel`.
        ///
        /// - Parameters:
        ///   - locality: City or locality name.
        ///   - postalCode: Postal code.
        ///   - streetAddress: Street name and number.
        ///   - area: Administrative area identifier.
        ///   - district: District identifier.
        public init(
            locality: String?,
            postalCode: String?,
            streetAddress: String?,
            area: IDWrapperModel?,
            district: IDWrapperModel?
        ) {
            self.locality = locality
            self.postalCode = postalCode
            self.streetAddress = streetAddress
            self.area = area
            self.district = district
        }
    }

    /// Wrapper model for identifier-based objects.
    final class IDWrapperModel: Codable {

        /// Identifier value.
        let id: String?

        /// Initializes an `IDWrapperModel`.
        ///
        /// - Parameters:
        ///   - id: Identifier value.
        public init(id: String?) {
            self.id = id
        }
    }

    /// Domain representation of organization information.
    public class OrganizationModel: Codable {

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

        /// Initializes an `OrganizationModel`.
        ///
        /// - Parameters:
        ///   - accesibility: Accessibility information.
        ///   - services: Services offered.
        ///   - schedule: Opening hours or schedule.
        ///   - organizationName: Organization name.
        ///   - organizationDesc: Organization description.
        public init(
            accesibility: String?,
            services: String?,
            schedule: String?,
            organizationName: String?,
            organizationDesc: String?
        ) {
            self.accesibility = accesibility
            self.services = services
            self.schedule = schedule
            self.organizationName = organizationName
            self.organizationDesc = organizationDesc
        }
    }

    /// Domain representation of recurrence rules.
    public class RecurrenceModel: Codable {

        /// Interval between recurrences.
        let interval: Int?
        /// Days on which the event occurs.
        let days: String?
        /// Recurrence frequency.
        let frequency: String?

        /// Initializes a `RecurrenceModel`.
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
