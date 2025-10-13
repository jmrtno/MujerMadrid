//
//  GetWomenCarePointDetailUseCase.swift
//  MujerMadrid
//
//  Created by Javier Martin on 19/7/25.
//

import Foundation
import FDependencyInjector

public protocol GetWomenCarePointDetailUseCaseContract: UseCaseContract {
    func run(_ params: GetWomenCarePointDetailParameters) async throws -> WomenCarePointModel
}

public class GetWomenCarePointDetailParameters {
    public let centerId: String
    
    public init(centerId: String) {
        self.centerId = centerId
    }
}

class GetWomenCarePointDetailUseCase: GetWomenCarePointDetailUseCaseContract {
    let womenCarePointRepository: WomenCarePointRepositoryContract

    required init() {
        @Injected var womenCarePointRepository: WomenCarePointRepositoryContract
        self.womenCarePointRepository = womenCarePointRepository
    }
    
    open func run(_ params: GetWomenCarePointDetailParameters) async throws -> WomenCarePointModel {
        let centersDetail = try await womenCarePointRepository.getWomanCarePointDetailInformation(centerId: params.centerId)
        try await womenCarePointRepository.saveDetailDataToLocal(centers: centersDetail)
        return WomenCarePointModel(data: centersDetail.data)
    }
}
