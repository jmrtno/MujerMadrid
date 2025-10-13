//
//  WomenCarePointDetailBuilder.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

import FComponents
import FDependencyInjector
import FPresentation
import SwiftUI

/// Builder of Detail
open class WomenCarePointDetailBuilder {
    /// ViewModel of the screen
    public var viewModel: WomenCarePointDetailViewModelContract
    /// Identifier of the product needed to navigate to the screen.
    @Dependency public var centerId: String

    /// Default init required by the injector
    public required init() {
        @Injected var viewModel: WomenCarePointDetailViewModelContract
        self.viewModel = viewModel
    }

    init(viewModel: WomenCarePointDetailViewModelContract) {
        self.viewModel = viewModel
    }
    
    /// This method builds the Detail screen.
    /// If you want to override this method:
    /// 1. Create a subclass of ClickToPayStep1Builder
    /// 2. Set up dependencies of the viewModel Ex: `viewModel.setupDependencies()`
    /// 3. Use ``WomenCarePointDetailScreen`` init using helper functions of this class, replacing the ones that you
    ///   want to customize
    open func build() -> any View {
        viewModel.setupDependencies(WomenCarePointDetailViewModelDependencies(centerId: centerId))
        return WomenCarePointDetailScreen(viewModel: viewModel,
                                          top: getTopView,
                                          content: getContentView,
                                          bottom: getBottomView,
                                          error: getErrorView,
                                          overlay: getOverlayView)
    }
    
    /// Function that sets the current identifier
    /// - Parameter centerId: identifier of the product
    /// - Returns: Self view with modifications
    open func setIdentifier(centerId: String) -> WomenCarePointDetailBuilder {
        self.centerId = centerId
        return self
    }
    
    /// Returns a view containing the loader section.
    ///
    /// - Returns: A view representing the loader overlay section.
    @ViewBuilder
    public func getOverlayView() -> some View {
        WomenCarePointDetailLoaderSectionView()
    }

    /// This function returns the elements to be placed as top view of the screen.
    @ViewBuilder
    public func getTopView() -> some View {
        @Injected var mapper: any WomenCarePointDetailHeaderSectionMapperContract
        if let mapperInstance = mapper as? WomenCarePointDetailHeaderSectionMapper {
            let publisher = mapperInstance.getObservedPublisher(viewModel as! WomenCarePointDetailHeaderSectionViewModelContract)
            let renderPublisher = publisher.map { domainModel in
                mapperInstance.map(domainModel)
            }.eraseToAnyPublisher()
            WomenCarePointDetailHeaderSectionView(viewModel: viewModel as! WomenCarePointDetailHeaderSectionViewModelContract,
                                                   publisher: renderPublisher)
        }
    }
    
    @ViewBuilder
    public func getContentView() -> some View {
        @Injected var mapper: any WomenCarePointDetailContentSectionMapperContract
        if let mapperInstance = mapper as? WomenCarePointDetailContentSectionMapper {
            let publisher = mapperInstance.getObservedPublisher(viewModel as! WomenCarePointDetailContentSectionViewModelContract)
            let renderPublisher = publisher.map { domainModel in
                mapperInstance.map(domainModel)
            }.eraseToAnyPublisher()
            WomenCarePointDetailContentSectionView(viewModel: viewModel as! WomenCarePointDetailContentSectionViewModelContract,
                                                   publisher: renderPublisher)
        }
    }

    @ViewBuilder
    public func getErrorView() -> some View {
        WomenCarePointDetailErrorSectionView(viewModel: viewModel as! WomenCarePointDetailErrorSectionViewModelContract)
    }
    
    @ViewBuilder
    public func getBottomView() -> some View {
        EmptyView()
    }
}

typealias WomenCarePointDetailErrorSectionViewModelContract = CrossErrorSectionViewModelContract
typealias WomenCarePointDetailErrorSectionView = CrossErrorSectionView
typealias WomenCarePointDetailLoaderSectionView = CrossLoaderSectionView
