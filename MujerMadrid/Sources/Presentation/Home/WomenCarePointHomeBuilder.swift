import FComponents
import FDependencyInjector
import FPresentation
import SwiftUI

/// Builder of the Women Care Point Home screen
@MainActor
final class WomenCarePointHomeBuilder {
    /// ViewModel of the screen
    public var viewModel: WomenCarePointHomeViewModelContract

    /// Default init required by the injector
    public required init() {
        @Injected var viewModel: WomenCarePointHomeViewModelContract
        self.viewModel = viewModel
    }

    /// Init with a specific ViewModel
    init(viewModel: WomenCarePointHomeViewModelContract) {
        self.viewModel = viewModel
    }
    
    /// Builds the Home screen.
    /// - Returns: A SwiftUI View representing the Women Care Point Home screen
    public func build() -> some View {
        viewModel.setupDependencies(WomenCarePointHomeViewModelDependencies())
        return WomenCarePointHomeScreen(viewModel: viewModel,
                                        top: getTopView,
                                        content: getContentView,
                                        bottom: getBottomView,
                                        error: getErrorView,
                                        overlay: getOverlayView)
    }
    
    // MARK: - Overlay
    /// Returns a view containing the loader section
    @ViewBuilder
    public func getOverlayView() -> some View {
        WomenCarePointHomeLoaderSectionView()
    }

    // MARK: - Top View
    /// Returns the top view of the screen
    @ViewBuilder
    public func getTopView() -> some View {
        WomenCarePointHomeHeaderSectionView(
            viewModel: viewModel as! WomenCarePointHomeHeaderSectionViewModelContract
        )
    }
    
    // MARK: - Content
    /// Returns the content view of the screen
    @ViewBuilder
    public func getContentView() -> some View {
        @Injected var mapper: any WomenCarePointHomeListSectionMapperContract
        if let mapperInstance = mapper as? WomenCarePointHomeListSectionMapper {
            let publisher = mapperInstance.getObservedPublisher(
                viewModel as! WomenCarePointHomeListSectionViewModelContract
            )
            let renderPublisher = publisher
                .map { domainModel in mapperInstance.map(domainModel) }
                .eraseToAnyPublisher()
            WomenCarePointHomeListSectionView(
                viewModel: viewModel as! WomenCarePointHomeListSectionViewModelContract,
                publisher: renderPublisher
            )
        }
    }
    
    // MARK: - Bottom View
    /// Returns the bottom view of the screen
    @ViewBuilder
    public func getBottomView() -> some View {
        WomenCarePointHomeFooterSectionView(
            viewModel: viewModel as! WomenCarePointHomeFooterSectionViewModelContract
        )
    }

    // MARK: - Error View
    /// Returns the error view of the screen
    @ViewBuilder
    public func getErrorView() -> some View {
        WomenCarePointHomeErrorSectionView(
            viewModel: viewModel as! WomenCarePointHomeErrorSectionViewModelContract
        )
    }
}

// MARK: - Typealiases for shared sections
typealias WomenCarePointHomeErrorSectionViewModelContract = CrossErrorSectionViewModelContract
typealias WomenCarePointHomeErrorSectionView = CrossErrorSectionView
typealias WomenCarePointHomeLoaderSectionView = CrossLoaderSectionView
