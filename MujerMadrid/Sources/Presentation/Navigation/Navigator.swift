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

final class Navigator: @unchecked Sendable, ScreenNavigator {
    
    public required init() {}

    public func  destinationFor(navigationInfo: NavigationInfo) throws -> (any View)? {
        guard let navigation = navigationInfo as? IncomingNavigation else {
            return nil
        }
        return try handleDestinationFor(navigationInfo: navigation)
    }
    
    @MainActor
    private func handleDestinationFor(navigationInfo: IncomingNavigation) throws -> (any View)? {
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
