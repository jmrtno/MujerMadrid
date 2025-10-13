//
//  Untitled.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

import FDependencyInjector

final class WomenCarePointDetailContentSectionModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register((any WomenCarePointDetailContentSectionMapperContract).self,
                                            WomenCarePointDetailContentSectionMapper.self)
    }
}
