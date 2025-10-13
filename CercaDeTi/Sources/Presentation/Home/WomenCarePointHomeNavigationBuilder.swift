//
//  WomenCarePointHomeNavigationBuilder.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

import FDependencyInjector
import FPresentation
import FNavigation
import UIKit

public protocol WomenCarePointHomeNavigationBuilderContract: NavigationBuilder {
    /// Navigation to Another Screen
    /// - Parameter identifier: identification of the <#product#>
    func navigateToCarePointDetail(centerId: String)
}

open class WomenCarePointHomeNavigationBuilder: WomenCarePointHomeNavigationBuilderContract {
    public required init() { /* Required by injector */ }
    
    open func navigateToCarePointDetail(centerId: String) {
        Router.shared.navigateTo(IncomingNavigation.detail(centerId: centerId), animated: true)
    }
    
    open func goBack(animated: Bool, screen: (any NavigationInfo)?, _ completion: (() -> Void)?) {
        Router.shared.goBack(animated: true, completion: completion)
    }
}
