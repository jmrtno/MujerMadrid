//
//  WomenCarePointDetailContentViewModelContract.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

import Combine

public protocol WomenCarePointDetailContentSectionViewModelContract {
    // MARK: - Outputs
    var womenCarePointDetailInformationPublisher: AnyPublisher<WomenCarePointDetailContentSectionObservedModel, Never> { get }
    // MARK: - Inputs
    func navigateTo(latitud: Double, longitud: Double)
}
