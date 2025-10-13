//
//  WomenCarePointHomeListSectionMapper.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

import Combine
import FDependencyInjector
import FPresentation

public protocol WomenCarePointHomeListSectionMapperContract: SectionMapperContract {}

final class WomenCarePointHomeListSectionMapper: WomenCarePointHomeListSectionMapperContract {
    typealias RenderModel = WomenCarePointHomeListSectionRenderModel
    typealias ViewModel = WomenCarePointHomeListSectionViewModelContract
    typealias ObservedModel = WomenCarePointHomeListSectionObservedModel
    
    @Dependency var viewModel: ViewModel
    
    func getObservedPublisher(_ viewModel: ViewModel) -> AnyPublisher<ObservedModel, Never> {
        viewModel.womenCarePointInformationPublisher
    }
    
    func map(_ model: ObservedModel) -> RenderModel {
        toRenderModel(model: model)
    }
}

private extension WomenCarePointHomeListSectionMapper {
    func toRenderModel(model: WomenCarePointHomeListSectionObservedModel) -> WomenCarePointHomeListSectionRenderModel {
        let centers: [WomenCarePointHomeListSectionRenderModel.Centers] = model.data?.compactMap { data in
            WomenCarePointHomeListSectionRenderModel.Centers(id: data.id ?? "",
                                                             title: data.title ?? "",
                                                             streetAddress: Utils().formatStreetAddress(data.address?.streetAddress),
                                                             postalCode: data.address?.postalCode ?? "",
                                                             locality: Utils().formatLocality(data.address?.locality),
                                                             schedule: data.organization?.schedule ?? "",
                                                             location: WomenCarePointHomeListSectionRenderModel.Location(
                                                                latitude: data.location?.latitude ?? 0.0,
                                                                longitude: data.location?.longitude ?? 0.0))
        } ?? []
        return WomenCarePointHomeListSectionRenderModel(centers: centers, showList: model.showList)
    }
}

