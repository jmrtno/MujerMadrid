//
//  CercaDeTiApp.swift
//  CercaDeTi
//
//  Created by Javier Martin on 5/8/25.
//

import FNavigation
import FDependencyInjector
import SwiftUI

@main
struct CercaDeTi: App {
    init() {
        DomainModule.inject()
        DataModule.inject()
        NavigationModule.inject()
        WomenCarePointHomeModule.inject()
        WomenCarePointHomeListSectionModule.inject()
        WomenCarePointDetailModule.inject()
        WomenCarePointDetailContentSectionModule.inject()
        WomenCarePointDetailHeaderSectionModule.inject()
        Router.shared.setRoot(IncomingNavigation.home, animated: false)
    }
    var body: some Scene {
        WindowGroup {
            NavigationManager.shared.environmentObject(Router.shared)
                .ignoresSafeArea()
        }
    }
}
