//
//  Navigator.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

//

import Foundation
import FNavigation
import SwiftUI

// Una clase responsable de devolver la vista apropiada basada en la información de navegación.
/// - handleDestinationFor(navigationInfo:): Devuelve la vista correspondiente según la información de navegación.
final class Navigator: ScreenNavigator {
    
    public required init() {}

    public func destinationFor(navigationInfo: any NavigationInfo) throws -> (any View)? {
        guard let navigation = navigationInfo as? IncomingNavigation else {
            return nil
        }
        let destination = try handleDestinationFor(navigationInfo: navigation)
        return destination
    }
    
    /// Maneja la vista de destino para la información de navegación dada.
    public func handleDestinationFor(navigationInfo: IncomingNavigation) throws -> (any View)? {
        switch navigationInfo {
        case .home:
            return WomenCarePointHomeBuilder()
                .build()
        case let .detail(centerId):
            return WomenCarePointDetailBuilder()
                .setIdentifier(centerId: centerId)
                .build()
        }
    }
}
