//
//  Untitled.swift
//  MujerMadrid
//
//  Created by Javier Martin on 16/7/25.
//

import FDependencyInjector
import Foundation

public protocol WomenCarePointDetailRemoteDataSourceContract: Instanciable {
    func getDetailInformation(centerId: String) async throws -> WomenCarePointDataEntity
}

final class WomenCarePointDetailRemoteDataSource: WomenCarePointDetailRemoteDataSourceContract {
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

    public func getDetailInformation(centerId: String) async throws -> WomenCarePointDataEntity {
        let resultAPI: Data = try await womenCarePointAPI.getWomanCarePointDetailInfo(centerId: centerId).execute()
        return try womenCarePointMapper.map(resultAPI)
    }
}
