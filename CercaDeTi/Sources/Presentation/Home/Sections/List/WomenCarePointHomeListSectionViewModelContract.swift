//
//  WomenCarePointHomeListViewModelContract.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

import Combine

protocol WomenCarePointHomeListSectionViewModelContract {
    // MARK: - Outputs
    var womenCarePointInformationPublisher: AnyPublisher<WomenCarePointHomeListSectionObservedModel, Never> { get }
    // MARK: - Inputs
    func getWomenCarePointInformationData()
    func navigateToCarePointDetail(centerId: String)
}
