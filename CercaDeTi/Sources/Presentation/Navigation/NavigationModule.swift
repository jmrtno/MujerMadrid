//
//  NavigationModule.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

import FDependencyInjector
import FNavigation

final class NavigationModule: ModuleContract {
    static func inject() {
        DependencyContainer.shared.register(ScreenNavigator.self, Navigator.self)
    }
}
