import FComponents
import FDependencyInjector
import FPresentation
import SwiftUI

struct WomenCarePointDetailScreen<Top: View,
                                  Content: View,
                                  Bottom: View>: View {
    private let content: Content
    private let top: Top
    private let bottom: Bottom
    private let viewModel: WomenCarePointDetailViewModelContract

    @SwiftUI.State private var viewSize: CGSize = .zero
    @AccessibilityFocusState private var isDetailTitleFocused: Bool

    /// Init of ``WomenCarePointDetailScreen`
    /// - Parameters:
    ///   - viewModel: viewModel linked to the view.
    ///   - top: View to be shown as top of the view (Fixed to the top).
    ///   - content: View to be shown as content of sections.
    ///   - bottom: View to be shown as bottom or footer of sections.
    public init(viewModel: WomenCarePointDetailViewModelContract,
                @ViewBuilder top: () -> Top,
                @ViewBuilder content: () -> Content,
                @ViewBuilder bottom: () -> Bottom) {
        self.content = content()
        self.top = top()
        self.bottom = bottom()
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            top
                .accessibilityFocused($isDetailTitleFocused)
            VStack {
                ScrollView {
                    content
                }
                bottom
            }
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
            )
            .padding(.top, viewModel.paddingSize)
            .ignoresSafeArea(edges: .bottom)
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .onAppear {
            viewModel.notifyAppearance()
        }
    }
}
