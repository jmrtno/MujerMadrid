//
//  WomenCarePointDetailHeaderViewModelContract.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//

import Combine
import Foundation

protocol WomenCarePointDetailHeaderSectionViewModelContract {
    // MARK: - Outputs
    var womenCarePointCenterHeaderInfoPublisher: AnyPublisher<WomenCarePointDetailHeaderSectionObservedModel, Never> { get }

    var headerHeight: CGFloat { get }

    // MARK: - Inputs
    func goBack()
}
