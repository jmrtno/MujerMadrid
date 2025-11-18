//
//  WomenCarePointDetailContentSectionMapper.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

import Combine
import FDependencyInjector
import FPresentation

public protocol WomenCarePointDetailContentSectionMapperContract: SectionMapperContract {}

final class WomenCarePointDetailContentSectionMapper: WomenCarePointDetailContentSectionMapperContract {
    typealias RenderModel = WomenCarePointDetailContentSectionRenderModel
    typealias ViewModel = WomenCarePointDetailContentSectionViewModelContract
    typealias ObservedModel = WomenCarePointDetailContentSectionObservedModel
    
    @Dependency var viewModel: ViewModel
    
    func getObservedPublisher(_ viewModel: ViewModel) -> AnyPublisher<ObservedModel, Never> {
        viewModel.womenCarePointDetailInformationPublisher
    }
    
    func map(_ model: ObservedModel) -> RenderModel {
        toRenderModel(model: model)
    }
}

private extension WomenCarePointDetailContentSectionMapper {
    func toRenderModel(model: WomenCarePointDetailContentSectionObservedModel) -> WomenCarePointDetailContentSectionRenderModel {
        guard let data = model.data?.first else {
            return WomenCarePointDetailContentSectionRenderModel()
        }

        let center = WomenCarePointDetailContentSectionRenderModel.Center(
            id: data.id ?? "",
            title: data.title ?? "",
            description: Utils().normalized(data.organization?.organizationDesc ?? ""),
            services: Utils().normalized(data.organization?.services ?? ""),
            streetAddress: Utils().formatStreetAddress(data.address?.streetAddress),
            postalCode: data.address?.postalCode ?? "",
            locality: Utils().formatLocality(data.address?.locality),
            schedule: data.organization?.schedule ?? "",
            location: WomenCarePointDetailContentSectionRenderModel.Location(latitude: data.location?.latitude ?? 0.0,
                                                                             longitude: data.location?.longitude ?? 0.0)
        )

        return WomenCarePointDetailContentSectionRenderModel(center: center)
    }
}
