//
//  WomenCarePointDetailModule.swift
//  MujerMadrid
//
//  Created by Javier Martin on 19/7/25.
//

import FDependencyInjector

final class WomenCarePointDetailModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register(WomenCarePointDetailViewModelContract.self, WomenCarePointDetailViewModel.self)
        DependencyContainer.shared.register(WomenCarePointDetailNavigationBuilderContract.self, WomenCarePointDetailNavigationBuilder.self)
    }
}
