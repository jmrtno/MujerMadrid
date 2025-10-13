//
//  IncomingNavigation.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

//

import Foundation
import FNavigation

// Una enumeración que representa las diferentes opciones de navegación.
/// - Enumera las posibles navegaciones (screenOne, screenTwo).
/// - presentationType: Define cómo se debe presentar cada pantalla (modal o push).
public enum IncomingNavigation: NavigationInfo {
    case home
    case detail(centerId: String)

    /// Determina el tipo de presentación para cada opción de navegación.
    public var presentationType: PresentationType {
        switch self {
        case .home:
            return .goToRoot
        case .detail:
            return .push
        }
    }
}

