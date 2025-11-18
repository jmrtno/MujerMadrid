//
//  WomenCarePointHomeModule.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

import FDependencyInjector

final class WomenCarePointHomeModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register(WomenCarePointHomeViewModelContract.self, WomenCarePointHomeViewModel.self)
        DependencyContainer.shared.register(WomenCarePointHomeNavigationBuilderContract.self, WomenCarePointHomeNavigationBuilder.self)
    }
}
