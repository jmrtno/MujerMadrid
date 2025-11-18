//
//  WomenCarePointHomeBuilder.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

import FComponents
import FDependencyInjector
import FPresentation
import SwiftUI

/// Builder of Home
@MainActor
final class WomenCarePointHomeBuilder {
    /// ViewModel of the screen
    public var viewModel: WomenCarePointHomeViewModelContract

    /// Default init required by the injector
    public required init() {
        @Injected var viewModel: WomenCarePointHomeViewModelContract
        self.viewModel = viewModel
    }

    init(viewModel: WomenCarePointHomeViewModelContract) {
        self.viewModel = viewModel
    }
    
    /// This method builds the Home screen.
    /// If you want to override this method:
    /// 1. Create a subclass of ClickToPayStep1Builder
    /// 2. Set up dependencies of the viewModel Ex: `viewModel.setupDependencies()`
    /// 3. Use ``WomenCarePointHomeScreen`` init using helper functions of this class, replacing the ones that you
    ///   want to customize
    public func build() -> any View {
        viewModel.setupDependencies(WomenCarePointHomeViewModelDependencies())
        return WomenCarePointHomeScreen(viewModel: viewModel,
                                        top: getTopView,
                                        content: getContentView,
                                        bottom: getBottomView,
                                        error: getErrorView,
                                        overlay: getOverlayView)
    }
    
    /// Returns a view containing the loader section.
    ///
    /// - Returns: A view representing the loader overlay section.
    @ViewBuilder
    public func getOverlayView() -> some View {
        WomenCarePointHomeLoaderSectionView()
    }

    /// This function returns the elements to be placed as top view of the screen.
    @ViewBuilder
    public func getTopView() -> some View {
        WomenCarePointHomeHeaderSectionView(viewModel: viewModel as! WomenCarePointHomeHeaderSectionViewModelContract)
    }
    
    @ViewBuilder
    public func getContentView() -> some View {
        @Injected var mapper: any WomenCarePointHomeListSectionMapperContract
        if let mapperInstance = mapper as? WomenCarePointHomeListSectionMapper {
            let publisher = mapperInstance.getObservedPublisher(viewModel as! WomenCarePointHomeListSectionViewModelContract)
            let renderPublisher = publisher.map { domainModel in
                mapperInstance.map(domainModel)
            }.eraseToAnyPublisher()
            WomenCarePointHomeListSectionView(viewModel: viewModel as! WomenCarePointHomeListSectionViewModelContract,
                                              publisher: renderPublisher)
        }
    }
    
    @ViewBuilder
    public func getBottomView() -> some View {
        WomenCarePointHomeFooterSectionView(viewModel: viewModel as! WomenCarePointHomeFooterSectionViewModelContract)
    }

    @ViewBuilder
    public func getErrorView() -> some View {
        WomenCarePointHomeErrorSectionView(viewModel: viewModel as! WomenCarePointHomeErrorSectionViewModelContract)
    }
}

typealias WomenCarePointHomeErrorSectionViewModelContract = CrossErrorSectionViewModelContract
typealias WomenCarePointHomeErrorSectionView = CrossErrorSectionView
typealias WomenCarePointHomeLoaderSectionView = CrossLoaderSectionView


