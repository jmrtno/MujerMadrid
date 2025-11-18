//
//  Untitled.swift
//  MujerMadrid
//
//  Created by Javier Martin on 16/7/25.
//

import FDependencyInjector
import Foundation

public protocol WomenCarePointHomeLocalDataSourceContract: Actor, Sendable, Instanciable {
    func getLocalHomeInformation() -> WomenCarePointDataEntity?
    func setLocalHomeInformation(entity: WomenCarePointDataEntity)
}

public actor WomenCarePointHomeLocalDataSource: @unchecked Sendable, WomenCarePointHomeLocalDataSourceContract {
    private var informationLocalDataSource: WomenCarePointDataEntity?
    
    public init() { }
    
    public func getLocalHomeInformation() -> WomenCarePointDataEntity? {
        return informationLocalDataSource
    }
    
    public func setLocalHomeInformation(entity: WomenCarePointDataEntity) {
        self.informationLocalDataSource = entity
    }
}
