//
//  WomenCarePointDetailViewModel.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

import Combine
import FDependencyInjector
import FPresentation
import Foundation
import MapKit

/// Dependencies of the WomenCarePointDetailViewModel
open class WomenCarePointDetailViewModelDependencies {
    /// identifier to access the screen
    public let centerId: String

    /// Initializer of the dependencies
    /// - Parameters:
    ///   - centerId: identifier of the product of the holders and beneficiaries
    public init(centerId: String) {
        self.centerId = centerId
    }
}

public protocol WomenCarePointDetailViewModelContract: ViewModelContract {
    // MARK: Dependencies
    /// Setup the dependencies of the viewModel
    /// - Parameter dependencies: dependencies of the viewModel
    func setupDependencies(_ dependencies: WomenCarePointDetailViewModelDependencies)
    
    // MARK: Inputs
    /// This method is called when the view appears
    func notifyAppearance()
    func getWomenCarePointDetailData()

    // MARK: Publishers
    var errorPublisher: AnyPublisher<Bool, Never> { get }
    var loaderPublisher: AnyPublisher<Bool, Never> { get }

    var paddingSize: CGFloat { get }
}

open class WomenCarePointDetailViewModel: WomenCarePointDetailViewModelContract,
                                          WomenCarePointDetailContentSectionViewModelContract,
                                          WomenCarePointDetailHeaderSectionViewModelContract,
                                          CrossErrorSectionViewModelContract {
    // MARK: - Dependencies
    @Dependency public var centerId: String

    // MARK: - UseCase
    let getWomenCarePointUseCase: GetWomenCarePointDetailUseCaseContract
    
    public required init() {
        @Injected var useCase: GetWomenCarePointDetailUseCaseContract
        @Injected var navigationBuilder: WomenCarePointDetailNavigationBuilderContract
        self.getWomenCarePointUseCase = useCase
        self.navigationBuilder = navigationBuilder
    }
    
    init(useCase: GetWomenCarePointDetailUseCaseContract,
         navigationBuilder: WomenCarePointDetailNavigationBuilderContract) {
        self.getWomenCarePointUseCase = useCase
        self.navigationBuilder = navigationBuilder
    }

    // MARK: - Published
    @Published public var womenCarePointDetailInformationPublished: WomenCarePointDetailContentSectionObservedModel = .init()
    @Published public var womenCarePointCenterHeaderInfoPublished: WomenCarePointDetailHeaderSectionObservedModel = .init()
    @Published var isLoading = false
    @Published var isError = false
    private let locationManager = LocationManager()
    private let smallNameIds: Set<String> = ["5433767", "184260"]
    private let longNameIds: Set<String> = ["11952990", "11089192"]
    
    // MARK: - Publishers
    open var womenCarePointDetailInformationPublisher: AnyPublisher<WomenCarePointDetailContentSectionObservedModel, Never> {
        $womenCarePointDetailInformationPublished.eraseToAnyPublisher()
    }
    
    open var womenCarePointCenterHeaderInfoPublisher: AnyPublisher<WomenCarePointDetailHeaderSectionObservedModel, Never> {
        $womenCarePointCenterHeaderInfoPublished.eraseToAnyPublisher()
    }
    
    open var loaderPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }

    open var errorPublisher: AnyPublisher<Bool, Never> {
        $isError.eraseToAnyPublisher()
    }
    
    /// NavigationBuilder use to navigate to another screen
    public var navigationBuilder: WomenCarePointDetailNavigationBuilderContract
    
    /// This method is called when the view appears
    open func notifyAppearance() {
        getWomenCarePointDetailData()
    }
    
    // MARK: - Dependencies
    /// Setup the dependencies of the viewModel
    /// - Parameter dependencies: dependencies of the viewModel
    open func setupDependencies(_ dependencies: WomenCarePointDetailViewModelDependencies) {
        self.centerId = dependencies.centerId
    }
    
    // MARK: - InitialData
    /// Loads the initial data
    open func getWomenCarePointDetailData() {
        loadData(for: centerId)
    }
    
    // MARK: - Section Inputs
    open func goBack() {
        navigationBuilder.goBack(animated: true, screen: nil, nil)
    }

    open func navigateTo(latitud: Double, longitud: Double) {
        let destinationCoordinate = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        destinationMapItem.name = womenCarePointCenterHeaderInfoPublished.title // opcional, muestra el nombre en Maps

        // Punto de partida = ubicación actual
        let currentLocationMapItem = MKMapItem.forCurrentLocation()

        // Opciones para mostrar la ruta en coche (puedes cambiar a .walking, .transit, etc.)
        let options = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]

        // Abre la app de Mapas con la ruta
        MKMapItem.openMaps(with: [currentLocationMapItem, destinationMapItem], launchOptions: options)
    }

    open var paddingSize: CGFloat {
        if smallNameIds.contains(centerId) {
            return 140
        } else if longNameIds.contains(centerId) {
            return 175
        } else {
            return 160
        }
    }

    open var headerHeight: CGFloat {
        if smallNameIds.contains(centerId) {
            return 220
        } else if longNameIds.contains(centerId) {
            return 255
        } else {
            return 240
        }
    }

    open func didTapTryAgain() {
        self.isLoading = true
        self.isError = false
        loadData(for: centerId)
    }
}

private extension WomenCarePointDetailViewModel {
    func loadData(for id: String) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.isLoading = true
            do {
                let useCase = self.getWomenCarePointUseCase
                let params =  GetWomenCarePointDetailParameters(centerId: self.centerId)
                let info = try await useCase.run(params)

                self.womenCarePointDetailInformationPublished = WomenCarePointDetailContentSectionObservedModel(
                    data: info.data
                )

                self.womenCarePointCenterHeaderInfoPublished.title = info.data.first?.title ?? ""
                self.womenCarePointCenterHeaderInfoPublished.description = info.data.first?.organization?.organizationDesc ?? ""
                self.womenCarePointCenterHeaderInfoPublished.services = info.data.first?.organization?.services ?? ""
                self.isError = false
                self.isLoading = false
                
            } catch {
                self.isLoading = false
                self.isError = true
            }
        }
    }

}
