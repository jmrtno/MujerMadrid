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
final class WomenCarePointHomeViewModelDependencies {}

protocol WomenCarePointHomeViewModelContract: ViewModelContract {
    // MARK: Dependencies
    func setupDependencies(_ dependencies: WomenCarePointHomeViewModelDependencies)
    
    // MARK: Inputs
    func notifyAppearance()
    func getWomenCarePointInformationData()

    // MARK: Publishers
    var errorPublisher: AnyPublisher<Bool, Never> { get }
    var loaderPublisher: AnyPublisher<Bool, Never> { get }
}

final class WomenCarePointHomeViewModel: WomenCarePointHomeViewModelContract,
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
    public var womenCarePointInformationPublisher: AnyPublisher<WomenCarePointHomeListSectionObservedModel, Never> {
        $womenCarePointInformationPublished.eraseToAnyPublisher()
    }
    
    public var loaderPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }

    public var errorPublisher: AnyPublisher<Bool, Never> {
        $isError.eraseToAnyPublisher()
    }

    /// NavigationBuilder use to navigate to another screen
    public var navigationBuilder: WomenCarePointHomeNavigationBuilderContract
    
    /// Called when the view appears
    public func notifyAppearance() {
        requestLocationPermissionsIfNeeded()
    }
    
    // MARK: - Dependencies
    public func setupDependencies(_ dependencies: WomenCarePointHomeViewModelDependencies) { }
    
    // MARK: - Initial Data
    public func getWomenCarePointInformationData() {
        loadData()
    }
    
    // MARK: - Section Inputs
    public func navigateToCarePointDetail(centerId: String) {
        navigationBuilder.navigateToCarePointDetail(centerId: centerId)
    }
    
    public func callNumber(number: String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    public func didTapToggle() {
        womenCarePointInformationPublished.showList.toggle()
    }

    public func didTapTryAgain() {
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
