//
//  WomenCarePointDetailNavigationBuilder.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

import FDependencyInjector
import FPresentation
import FNavigation
import UIKit

public protocol WomenCarePointDetailNavigationBuilderContract: NavigationBuilder {}

open class WomenCarePointDetailNavigationBuilder: WomenCarePointDetailNavigationBuilderContract {
    public required init() { /* Required by injector */ }

    open func goBack(animated: Bool, screen: (any NavigationInfo)?, _ completion: (() -> Void)?) {
        Router.shared.goBack(animated: true, completion: completion)
    }
}
