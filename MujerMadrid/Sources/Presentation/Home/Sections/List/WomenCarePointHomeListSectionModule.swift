//
//  Untitled.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

import FDependencyInjector

final class WomenCarePointHomeListSectionModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register((any WomenCarePointHomeListSectionMapperContract).self,
                                            WomenCarePointHomeListSectionMapper.self)
    }
}
