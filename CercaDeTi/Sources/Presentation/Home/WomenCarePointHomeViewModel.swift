//
//  WomenCarePointHomeViewModel.swift
//  MujerMadrid
//

import Combine
import FDependencyInjector
import Foundation
import FPresentation
import MapKit
import SwiftUI

/// Dependencies of the WomenCarePointHomeViewModel
open class WomenCarePointHomeViewModelDependencies {}

public protocol WomenCarePointHomeViewModelContract: ViewModelContract {
    // MARK: Dependencies
    func setupDependencies(_ dependencies: WomenCarePointHomeViewModelDependencies)
    
    // MARK: Inputs
    func notifyAppearance()
    func getWomenCarePointInformationData()

    // MARK: Publishers
    var errorPublisher: AnyPublisher<Bool, Never> { get }
    var loaderPublisher: AnyPublisher<Bool, Never> { get }
}

open class WomenCarePointHomeViewModel: WomenCarePointHomeViewModelContract,
                                        WomenCarePointHomeListSectionViewModelContract,
                                        WomenCarePointHomeFooterSectionViewModelContract,
                                        WomenCarePointHomeHeaderSectionViewModelContract,
                                        CrossErrorSectionViewModelContract {

    // MARK: - UseCase
    let getWomenCarePointUseCase: GetWomenCarePointHomeUseCaseContract
    
    public required init() {
        @Injected var useCase: GetWomenCarePointHomeUseCaseContract
        @Injected var navigationBuilder: WomenCarePointHomeNavigationBuilderContract
        self.getWomenCarePointUseCase = useCase
        self.navigationBuilder = navigationBuilder
    }
    
    init(useCase: GetWomenCarePointHomeUseCaseContract,
         navigationBuilder: WomenCarePointHomeNavigationBuilderContract) {
        self.getWomenCarePointUseCase = useCase
        self.navigationBuilder = navigationBuilder
    }

    // MARK: - Published
    @Published public var womenCarePointInformationPublished: WomenCarePointHomeListSectionObservedModel = .init()
    @Published var isLoading = false
    @Published var isError = false
    private let locationManager = CLLocationManager()
    
    // MARK: - Publishers
    open var womenCarePointInformationPublisher: AnyPublisher<WomenCarePointHomeListSectionObservedModel, Never> {
        $womenCarePointInformationPublished.eraseToAnyPublisher()
    }
    
    open var loaderPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }

    open var errorPublisher: AnyPublisher<Bool, Never> {
        $isError.eraseToAnyPublisher()
    }

    /// NavigationBuilder use to navigate to another screen
    public var navigationBuilder: WomenCarePointHomeNavigationBuilderContract
    
    /// Called when the view appears
    open func notifyAppearance() {
        requestLocationPermissionsIfNeeded()
    }
    
    // MARK: - Dependencies
    open func setupDependencies(_ dependencies: WomenCarePointHomeViewModelDependencies) { }
    
    // MARK: - Initial Data
    open func getWomenCarePointInformationData() {
        loadData()
    }
    
    // MARK: - Section Inputs
    open func navigateToCarePointDetail(centerId: String) {
        navigationBuilder.navigateToCarePointDetail(centerId: centerId)
    }
    
    open func callNumber(number: String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    open func didTapToggle() {
        womenCarePointInformationPublished.showList.toggle()
    }

    open func didTapTryAgain() {
        self.isLoading = true
        self.isError = false
        loadData()
    }
}

private extension WomenCarePointHomeViewModel {
    func loadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.isLoading = true
            do {
                let info = try await self.getWomenCarePointUseCase.run()
                self.womenCarePointInformationPublished.data = info.data
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.isError = true
            }
        }
    }
    
    private func requestLocationPermissionsIfNeeded() {
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
