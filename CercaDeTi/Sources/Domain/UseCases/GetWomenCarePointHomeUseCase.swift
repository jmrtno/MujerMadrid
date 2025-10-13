//
//  GetWomenCarePointUseCase.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

import Foundation
import FDependencyInjector

public protocol GetWomenCarePointHomeUseCaseContract: UseCaseContract {
    func run() async throws -> WomenCarePointModel
}

class GetWomenCarePointHomeUseCase: GetWomenCarePointHomeUseCaseContract {
    let womenCarePointRepository: WomenCarePointRepositoryContract

    required init() {
        @Injected var womenCarePointRepository: WomenCarePointRepositoryContract
        self.womenCarePointRepository = womenCarePointRepository
    }
    
    open func run() async throws -> WomenCarePointModel {
        let centers = try await womenCarePointRepository.getWomanCarePointHomeInformation()
        try await womenCarePointRepository.saveHomeDataToLocal(centers: centers)
        return WomenCarePointModel(data: centers.data)
    }
}
