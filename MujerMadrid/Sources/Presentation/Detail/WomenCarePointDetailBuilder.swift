import FComponents
import FDependencyInjector
import FPresentation
import SwiftUI

/// Builder for the WomenCarePoint Detail screen
/// Handles construction of the screen, including top, content, bottom, error, and overlay sections
@MainActor
final class WomenCarePointDetailBuilder {
    /// ViewModel of the screen
    public var viewModel: WomenCarePointDetailViewModelContract
    
    /// Complete data of the care point
    public var centerData: WomenCarePointModel.EventModel?

    /// Default initializer required by FDependencyInjector
    public required init() {
        @Injected var viewModel: WomenCarePointDetailViewModelContract
        self.viewModel = viewModel
    }

    /// Custom initializer for manual injection (e.g., testing)
    /// - Parameter viewModel: instance of the ViewModel
    init(viewModel: WomenCarePointDetailViewModelContract) {
        self.viewModel = viewModel
    }
    
    // MARK: - Build Method
    /// Builds the full Detail screen view
    /// Steps to override:
    /// 1. Subclass `WomenCarePointDetailBuilder`
    /// 2. Set up ViewModel dependencies (`viewModel.setupDependencies(...)`)
    /// 3. Use `WomenCarePointDetailScreen` init with the helper methods below
    public func build() -> any View {
        guard let centerData else {
            fatalError("centerData must be set before calling build()")
        }
        viewModel.setupDependencies(WomenCarePointDetailViewModelDependencies(centerData: centerData))
        return WomenCarePointDetailScreen(
            viewModel: viewModel,
            top: getTopView,
            content: getContentView,
            bottom: getBottomView
        )
    }
    
    // MARK: - Configuration
    /// Sets the complete center data
    /// - Parameter centerData: complete data of the care point
    /// - Returns: Self builder instance with the updated centerData
    public func setCenterData(_ centerData: WomenCarePointModel.EventModel) -> WomenCarePointDetailBuilder {
        self.centerData = centerData
        return self
    }
    
    // MARK: - Top Section
    /// Returns the top section of the screen (header)
    @ViewBuilder
    public func getTopView() -> some View {
        @Injected var mapper: any WomenCarePointDetailHeaderSectionMapperContract
        if let mapperInstance = mapper as? WomenCarePointDetailHeaderSectionMapper {
            let publisher = mapperInstance.getObservedPublisher(viewModel as! WomenCarePointDetailHeaderSectionViewModelContract)
            let renderPublisher = publisher
                .map { domainModel in mapperInstance.map(domainModel) }
                .eraseToAnyPublisher()
            
            WomenCarePointDetailHeaderSectionView(
                viewModel: viewModel as! WomenCarePointDetailHeaderSectionViewModelContract,
                publisher: renderPublisher
            )
        }
    }
    
    // MARK: - Content Section
    /// Returns the main content section of the screen
    @ViewBuilder
    public func getContentView() -> some View {
        @Injected var mapper: any WomenCarePointDetailContentSectionMapperContract
        if let mapperInstance = mapper as? WomenCarePointDetailContentSectionMapper {
            let publisher = mapperInstance.getObservedPublisher(viewModel as! WomenCarePointDetailContentSectionViewModelContract)
            let renderPublisher = publisher
                .map { domainModel in mapperInstance.map(domainModel) }
                .eraseToAnyPublisher()
            
            WomenCarePointDetailContentSectionView(
                viewModel: viewModel as! WomenCarePointDetailContentSectionViewModelContract,
                publisher: renderPublisher
            )
        }
    }

    // MARK: - Bottom Section
    /// Returns the bottom section view; empty in this case
    @ViewBuilder
    public func getBottomView() -> some View {
        EmptyView()
    }
}
