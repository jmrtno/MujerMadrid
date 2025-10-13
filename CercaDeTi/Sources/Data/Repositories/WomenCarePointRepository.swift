//
//  WomenCarePointRepository.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

import FDependencyInjector
import Foundation

open class WomenCarePointRepository: @unchecked Sendable,
                                     WomenCarePointRepositoryContract {
    let homeRemoteDataSource: WomenCarePointHomeRemoteDataSourceContract
    let detailRemoteDataSource: WomenCarePointDetailRemoteDataSourceContract
    let homeLocalDataSource: WomenCarePointHomeLocalDataSourceContract
    let detailLocalDataSource: WomenCarePointDetailLocalDataSourceContract
    let getWomenCarePointEntityMapper: WomenCarePointMapperContract
    
    public required init() {
        @Injected var homeRemoteDataSource: WomenCarePointHomeRemoteDataSourceContract
        @Injected var detailRemoteDataSource: WomenCarePointDetailRemoteDataSourceContract
        @Injected var homeLocalDataSource: WomenCarePointHomeLocalDataSourceContract
        @Injected var detailLocalDataSource: WomenCarePointDetailLocalDataSourceContract
        @Injected var getWomenCarePointEntityMapper: WomenCarePointMapperContract
        self.homeRemoteDataSource = homeRemoteDataSource
        self.detailRemoteDataSource = detailRemoteDataSource
        self.homeLocalDataSource = homeLocalDataSource
        self.detailLocalDataSource = detailLocalDataSource
        self.getWomenCarePointEntityMapper = getWomenCarePointEntityMapper
    }
    
    init(homeRemoteDataSource: WomenCarePointHomeRemoteDataSourceContract,
         detailRemoteDataSource: WomenCarePointDetailRemoteDataSourceContract,
         homeLocalDataSource: WomenCarePointHomeLocalDataSourceContract,
         detailLocalDataSource: WomenCarePointDetailLocalDataSourceContract,
         getWomenCarePointEntityMapper: WomenCarePointMapperContract) {
        self.homeRemoteDataSource = homeRemoteDataSource
        self.detailRemoteDataSource = detailRemoteDataSource
        self.homeLocalDataSource = homeLocalDataSource
        self.detailLocalDataSource = detailLocalDataSource
        self.getWomenCarePointEntityMapper = getWomenCarePointEntityMapper
    }
    
    open func getWomanCarePointHomeInformation() async throws -> WomenCarePointModel {
        let localCenters = try await getCentersHomeInfoFromLocalData()
        if localCenters.data.isEmpty {
            return try await getCentersHomeInfoFromRemoteData()
        }
        return localCenters
    }
    
    open func getWomanCarePointDetailInformation(centerId: String) async throws -> WomenCarePointModel {
        let localCenters = try await getCentersDetailInfoFromLocalData(centerId: centerId)
        if localCenters.data.isEmpty {
            return try await getCentersDetailInfoFromRemoteData(centerId: centerId)
        }
        return localCenters
    }

    open func saveHomeDataToLocal(centers: WomenCarePointModel) async throws {
        let entity = try getWomenCarePointEntityMapper.map(centers)
        await homeLocalDataSource.setLocalHomeInformation(entity: entity)
    }

    open func saveDetailDataToLocal(centers: WomenCarePointModel) async throws {
        let entity = try getWomenCarePointEntityMapper.map(centers)
        await detailLocalDataSource.setLocalDetailInformation(entity: entity)
    }
}

private extension WomenCarePointRepository {
    func getCentersHomeInfoFromRemoteData() async throws -> WomenCarePointModel {
        let centersEntity = try await homeRemoteDataSource.getHomeInformation()
        return try getWomenCarePointEntityMapper.map(centersEntity)
    }

    func getCentersHomeInfoFromLocalData() async throws -> WomenCarePointModel {
        if let centersEntity = await homeLocalDataSource.getLocalHomeInformation() {
            return try getWomenCarePointEntityMapper.map(centersEntity)
        } else {
            return WomenCarePointModel(data: [])
        }
    }

    func getCentersDetailInfoFromRemoteData(centerId: String) async throws -> WomenCarePointModel {
        let centerDetailsEntity = try await detailRemoteDataSource.getDetailInformation(centerId: centerId)
        return try getWomenCarePointEntityMapper.map(centerDetailsEntity)
    }

    func getCentersDetailInfoFromLocalData(centerId: String) async throws -> WomenCarePointModel {
        if let centerDetailsEntity = await detailLocalDataSource.getLocalDetailInformation(centerId: centerId) {
            return try getWomenCarePointEntityMapper.map(centerDetailsEntity)
        } else {
            return WomenCarePointModel(data: [])
        }
    }
}
