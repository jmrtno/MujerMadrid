//
//  Untitled.swift
//  MujerMadrid
//
//  Created by Javier Martin on 16/7/25.
//

import FDependencyInjector
import Foundation

public protocol WomenCarePointHomeRemoteDataSourceContract: Instanciable {
    func getHomeInformation() async throws -> WomenCarePointDataEntity
}

final class WomenCarePointHomeRemoteDataSource: WomenCarePointHomeRemoteDataSourceContract {
    var womenCarePointMapper: WomenCarePointMapperContract
    var womenCarePointAPI: WomenCarePointAPIContract
    
    public required init() {
        @Injected var womenCarePointMapper: WomenCarePointMapperContract
        @Injected var womenCarePointAPI: WomenCarePointAPIContract
        self.womenCarePointMapper = womenCarePointMapper
        self.womenCarePointAPI = womenCarePointAPI
    }
    
    init(womenCarePointMapper: WomenCarePointMapperContract,
         womenCarePointAPI: WomenCarePointAPIContract) {
        self.womenCarePointMapper = womenCarePointMapper
        self.womenCarePointAPI = womenCarePointAPI
    }
    
    public func getHomeInformation() async throws -> WomenCarePointDataEntity {
        let resultAPI: Data = try await womenCarePointAPI.getWomanCarePointHomeInfo().execute()
        return try womenCarePointMapper.map(resultAPI)
    }
}
