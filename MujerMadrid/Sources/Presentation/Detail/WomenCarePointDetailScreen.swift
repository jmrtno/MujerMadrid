import FComponents
import FDependencyInjector
import FPresentation
import SwiftUI

struct WomenCarePointDetailScreen<Top: View,
                                  Content: View,
                                  Bottom: View,
                                  Error: View,
                                  Overlay: View>: View {
    private let content: Content
    private let top: Top
    private let bottom: Bottom
    private let error: Error
    private let overlay: Overlay
    private let viewModel: WomenCarePointDetailViewModelContract

    @SwiftUI.State private var viewSize: CGSize = .zero
    @SwiftUI.State private var showError = false
    @SwiftUI.State private var showLoader = false
    
    @AccessibilityFocusState private var isDetailTitleFocused: Bool
    @AccessibilityFocusState private var loaderFocused: Bool
    @AccessibilityFocusState private var errorFocused: Bool

    /// Init of ``WomenCarePointDetailScreen`
    /// - Parameters:
    ///   - viewModel: viewModel linked to the view.
    ///   - top: View to be shown as top of the view (Fixed to the top).
    ///   - content: View to be shown as content of sections.
    ///   - bottom: View to be shown as bottom or footer of sections.
    ///   - overlay: View to be shown as z-indexed overlay.
    public init(viewModel: WomenCarePointDetailViewModelContract,
                @ViewBuilder top: () -> Top,
                @ViewBuilder content: () -> Content,
                @ViewBuilder bottom: () -> Bottom,
                @ViewBuilder error: () -> Error,
                @ViewBuilder overlay: () -> Overlay) {
        self.content = content()
        self.top = top()
        self.bottom = bottom()
        self.error = error()
        self.overlay = overlay()
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            top
                .hiddenOrRemoved(showError || showLoader, remove: true)
                .accessibilityFocused($isDetailTitleFocused)
            VStack {
                ScrollView {
                    content
                }
                bottom
            }
            .hiddenOrRemoved(showError || showLoader, remove: true)
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
            )
            .padding(.top, viewModel.paddingSize)
            .ignoresSafeArea(edges: .bottom)
            if showError {
                error
                    /// Force error accessibility focus
                    .accessibilityFocused($errorFocused)
                    .onAppear {
                        errorFocused = true
                    }
            }
            if showLoader {
                overlay
                    /// Force loader accessibility focus
                    .accessibilityFocused($loaderFocused)
                    .onAppear {
                        loaderFocused = true
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .onAppear {
            viewModel.notifyAppearance()
        }
        .onReceive(viewModel.errorPublisher) {
            showError = $0
            if !$0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    errorFocused = true
                }
            }
        }
        .onReceive(viewModel.loaderPublisher) {
            showLoader = $0
            if !$0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isDetailTitleFocused = true
                }
            }
        }
    }
}
