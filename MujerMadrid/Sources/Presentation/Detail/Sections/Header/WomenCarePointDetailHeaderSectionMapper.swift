//
//  WomenCarePointDetailHeaderSectionMapper.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

import Combine
import FDependencyInjector
import FPresentation

public protocol WomenCarePointDetailHeaderSectionMapperContract: SectionMapperContract {}

final class WomenCarePointDetailHeaderSectionMapper: WomenCarePointDetailHeaderSectionMapperContract {
    typealias RenderModel = WomenCarePointDetailHeaderSectionRenderModel
    typealias ViewModel = WomenCarePointDetailHeaderSectionViewModelContract
    typealias ObservedModel = WomenCarePointDetailHeaderSectionObservedModel
    
    @Dependency var viewModel: ViewModel
    
    func getObservedPublisher(_ viewModel: ViewModel) -> AnyPublisher<WomenCarePointDetailHeaderSectionObservedModel, Never> {
        viewModel.womenCarePointCenterHeaderInfoPublisher
    }
    
    func map(_ model: ObservedModel) -> RenderModel {
        let title = model.title.split(whereSeparator: { $0 == "." || $0 == "(" })
            .first
            .map(String.init) ?? ""
        let description = model.description
        let services = model.services
        return WomenCarePointDetailHeaderSectionRenderModel(title: title,
                                                            centerType: getCenterType(description: description,
                                                                                      services: services))
    }
}

private extension WomenCarePointDetailHeaderSectionMapper {
    func getCenterType(description: String, services: String) -> String {
        // Definimos el orden fijo y su texto legible
        let orderedTypes: [(key: String, value: String)] = [
            ("psicol", "psicológica"),
            ("social", "social"),
            ("jur", "jurídica"),
            ("profes", "desarrollo profesional")
        ]
        
        // Buscamos las coincidencias respetando el orden
        let foundTypes = orderedTypes.compactMap { key, value in
            (description.localizedCaseInsensitiveContains(key) ||
             services.localizedCaseInsensitiveContains(key)) ? value : nil
        }
        
        // Componemos el texto final
        switch foundTypes.count {
        case 0:
            return "Centro de ayuda"
        case 1:
            return "Atención \(foundTypes[0])"
        case 2:
            return "Atención \(foundTypes[0]) y \(foundTypes[1])"
        default:
            let allButLast = foundTypes.dropLast().joined(separator: ", ")
            let last = foundTypes.last!
            return "Atención \(allButLast) y \(last)"
        }
    }
}


