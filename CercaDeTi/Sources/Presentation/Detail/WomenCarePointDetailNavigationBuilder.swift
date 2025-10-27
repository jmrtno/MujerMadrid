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

protocol WomenCarePointDetailNavigationBuilderContract: NavigationBuilder {}

final class WomenCarePointDetailNavigationBuilder: WomenCarePointDetailNavigationBuilderContract {
    public required init() { /* Required by injector */ }

    public func goBack(animated: Bool, screen: (any NavigationInfo)?, _ completion: (() -> Void)?) {
        Router.shared.goBack(animated: true, completion: completion)
    }
}
