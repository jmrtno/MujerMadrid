//
//  IncomingNavigation.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

//

import Foundation
import FNavigation

public enum IncomingNavigation: NavigationInfo {
    case home
    case detail(centerId: String)

    public var presentationType: PresentationType {
        switch self {
        case .home:
            return .goToRoot
        case .detail:
            return .push
        }
    }
}

