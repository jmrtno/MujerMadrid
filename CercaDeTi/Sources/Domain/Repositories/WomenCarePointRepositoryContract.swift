//
//  WomenCarePointRepositoryContract.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

import FDependencyInjector

public protocol WomenCarePointRepositoryContract: Instanciable {

    func getWomanCarePointHomeInformation() async throws -> WomenCarePointModel
    func getWomanCarePointDetailInformation(centerId: String) async throws -> WomenCarePointModel
    func saveHomeDataToLocal(centers: WomenCarePointModel) async throws
}
