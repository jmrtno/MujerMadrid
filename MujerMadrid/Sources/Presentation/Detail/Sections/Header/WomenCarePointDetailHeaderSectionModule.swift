//
//  Untitled.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

import FDependencyInjector

final class WomenCarePointDetailHeaderSectionModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register((any WomenCarePointDetailHeaderSectionMapperContract).self,
                                            WomenCarePointDetailHeaderSectionMapper.self)
    }
}
