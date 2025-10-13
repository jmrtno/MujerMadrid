//
//  Untitled.swift
//  MujerMadrid
//
//  Created by Javier Martin on 16/7/25.
//

import FDependencyInjector
import Foundation

public protocol WomenCarePointDetailLocalDataSourceContract: Actor, Sendable, Instanciable {
    func getLocalDetailInformation(centerId: String) -> WomenCarePointDataEntity?
    func setLocalDetailInformation(entity: WomenCarePointDataEntity)
}

public actor WomenCarePointDetailLocalDataSource: @unchecked Sendable, WomenCarePointDetailLocalDataSourceContract {
    private var informationLocalDataSource: WomenCarePointDataEntity?
    
    public init() { }
    
    public func getLocalDetailInformation(centerId: String) -> WomenCarePointDataEntity? {
        return informationLocalDataSource
    }
    
    public func setLocalDetailInformation(entity: WomenCarePointDataEntity) {
        self.informationLocalDataSource = entity
    }
}
