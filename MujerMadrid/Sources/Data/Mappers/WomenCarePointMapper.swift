import FDependencyInjector
import FData
import Foundation

/// Contract that defines the mapping responsibilities between
/// raw data, data entities and domain models for Women Care Points.
protocol WomenCarePointMapperContract: Sendable, Instanciable {

    /// Maps raw `Data` into a `WomenCarePointDataEntity`.
    ///
    /// - Parameter input: Raw data returned by the API.
    /// - Returns: A decoded `WomenCarePointDataEntity`.
    /// - Throws: An error if decoding fails.
    func map(_ input: Data) throws -> WomenCarePointDataEntity

    /// Maps a data entity into a domain model.
    ///
    /// - Parameter input: A `WomenCarePointDataEntity` from the data layer.
    /// - Returns: A `WomenCarePointModel` ready to be used in the domain or presentation layer.
    /// - Throws: An error if mapping fails.
    func map(_ input: WomenCarePointDataEntity) throws -> WomenCarePointModel

    /// Maps a domain model back into a data entity.
    ///
    /// This mapping is typically used for caching or persistence purposes.
    ///
    /// - Parameter input: A `WomenCarePointModel` from the domain layer.
    /// - Returns: A `WomenCarePointDataEntity` suitable for storage or serialization.
    /// - Throws: An error if mapping fails.
    func map(_ input: WomenCarePointModel) throws -> WomenCarePointDataEntity
}

/// Default implementation of `WomenCarePointMapperContract`.
///
/// This mapper acts as the translation layer between:
/// - Raw API responses (`Data`)
/// - Data entities (`WomenCarePointDataEntity`)
/// - Domain models (`WomenCarePointModel`)
final class WomenCarePointMapper: @unchecked Sendable, WomenCarePointMapperContract {

    /// Required initializer for dependency injection.
    public required init() {}

    /// Decodes raw API data into a `WomenCarePointDataEntity`.
    ///
    /// - Parameter input: Raw data returned by the API.
    /// - Returns: A decoded `WomenCarePointDataEntity`.
    /// - Throws: An error if decoding fails.
    public func map(_ input: Data) throws -> WomenCarePointDataEntity {
        return try input.map(WomenCarePointDataEntity.self)
    }

    /// Maps a `WomenCarePointDataEntity` into a `WomenCarePointModel`.
    ///
    /// This method transforms API-oriented structures into
    /// domain-friendly models.
    ///
    /// - Parameter input: Data entity containing raw API information.
    /// - Returns: A `WomenCarePointModel` with mapped domain data.
    /// - Throws: An error if mapping fails.
    public func map(_ input: WomenCarePointDataEntity) throws -> WomenCarePointModel {
        guard let dataInfo = input.graph else {
            return WomenCarePointModel(data: [])
        }

        let data = dataInfo.compactMap { entity in
            let id = entity?.id
            let uid = entity?.uid
            let dtstart = entity?.dtstart
            let dtend = entity?.dtend
            let title = entity?.title
            let description = entity?.description
            let link = entity?.link
            let relation = entity?.relation
            let references = entity?.references
            let eventLocation = entity?.eventLocation
            let excludedDays = entity?.excludedDays
            let price = entity?.price

            let location = WomenCarePointModel.LocationModel(
                latitude: entity?.location?.latitude,
                longitude: entity?.location?.longitude
            )

            let address = WomenCarePointModel.AddressModel(
                locality: entity?.address?.locality,
                postalCode: entity?.address?.postalCode,
                streetAddress: entity?.address?.streetAddress,
                area: WomenCarePointModel.IDWrapperModel(id: entity?.address?.area?.id),
                district: WomenCarePointModel.IDWrapperModel(id: entity?.address?.district?.id)
            )

            let organization = WomenCarePointModel.OrganizationModel(
                accesibility: entity?.organization?.accesibility,
                services: entity?.organization?.services,
                schedule: entity?.organization?.schedule,
                organizationName: entity?.organization?.organizationName,
                organizationDesc: entity?.organization?.organizationDesc
            )

            let recurrence = WomenCarePointModel.RecurrenceModel(
                interval: entity?.recurrence?.interval,
                days: entity?.recurrence?.days,
                frequency: entity?.recurrence?.frequency
            )

            let type = entity?.type
            let url = entity?.url

            return WomenCarePointModel.EventModel(
                id: id,
                uid: uid,
                dtstart: dtstart,
                dtend: dtend,
                title: title,
                description: description,
                link: link,
                relation: relation,
                references: references,
                eventLocation: eventLocation,
                excludedDays: excludedDays,
                price: price,
                location: location,
                address: address,
                organization: organization,
                recurrence: recurrence,
                type: type,
                url: url
            )
        }

        return WomenCarePointModel(data: data)
    }

    /// Maps a `WomenCarePointModel` back into a `WomenCarePointDataEntity`.
    ///
    /// This method is typically used when storing or caching
    /// domain data back into a data-layer representation.
    ///
    /// - Parameter input: Domain model containing Women Care Points information.
    /// - Returns: A `WomenCarePointDataEntity` suitable for persistence.
    /// - Throws: An error if mapping fails.
    public func map(_ input: WomenCarePointModel) throws -> WomenCarePointDataEntity {
        let events:[WomenCarePointDataEntity.Event?] = input.data.map { modelEvent in

            let location = modelEvent.location.map {
                WomenCarePointDataEntity.Location(
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            }

            let address = modelEvent.address.map {
                WomenCarePointDataEntity.Address(
                    locality: $0.locality,
                    postalCode: $0.postalCode,
                    streetAddress: $0.streetAddress,
                    area: $0.area.map { WomenCarePointDataEntity.IDWrapper(id: $0.id) },
                    district: $0.district.map { WomenCarePointDataEntity.IDWrapper(id: $0.id) }
                )
            }

            let organization = modelEvent.organization.map {
                WomenCarePointDataEntity.Organization(
                    accesibility: $0.accesibility,
                    services: $0.services,
                    schedule: $0.schedule,
                    organizationName: $0.organizationName,
                    organizationDesc: $0.organizationDesc
                )
            }

            let recurrence = modelEvent.recurrence.map {
                WomenCarePointDataEntity.Recurrence(
                    interval: $0.interval,
                    days: $0.days,
                    frequency: $0.frequency
                )
            }

            return WomenCarePointDataEntity.Event(
                id: modelEvent.id,
                uid: modelEvent.uid,
                dtstart: modelEvent.dtstart,
                dtend: modelEvent.dtend,
                title: modelEvent.title,
                description: modelEvent.description,
                link: modelEvent.link,
                relation: modelEvent.relation,
                references: modelEvent.references,
                eventLocation: modelEvent.eventLocation,
                excludedDays: modelEvent.excludedDays,
                price: modelEvent.price,
                location: location,
                address: address,
                organization: organization,
                recurrence: recurrence,
                type: modelEvent.type,
                url: modelEvent.url
            )
        }

        return WomenCarePointDataEntity(graph: events)
    }
}
