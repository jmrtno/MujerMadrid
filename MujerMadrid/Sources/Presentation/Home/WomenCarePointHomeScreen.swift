import FComponents
import FDependencyInjector
import FPresentation
import SwiftUI

struct WomenCarePointHomeScreen<Top: View,
                                Content: View,
                                Bottom: View,
                                Overlay: View,
                                Error: View>: View {
    private let content: Content
    private let top: Top
    private let bottom: Bottom
    private let overlay: Overlay
    private let error: Error
    private let viewModel: WomenCarePointHomeViewModelContract

    @SwiftUI.State private var showError = false
    @SwiftUI.State private var showLoader = false
    @SwiftUI.State private var didReachBottom = false
    @SwiftUI.State private var scrollViewHeight: CGFloat = 0

    private let bottomDetectionMargin: CGFloat = 20
    
    @AccessibilityFocusState private var isTitleFocused: Bool
    @AccessibilityFocusState private var loaderFocused: Bool
    @AccessibilityFocusState private var errorFocused: Bool

    /// Init of ``WomenCarePointHomeScreen`
    /// - Parameters:
    ///   - viewModel: viewModel linked to the view.
    ///   - top: View to be shown as top of the view (Fixed to the top).
    ///   - content: View to be shown as content of sections.
    ///   - bottom: View to be shown as bottom or footer of sections.
    ///   - error: View to be shown as error section.
    ///   - overlay: View to be shown as z-indexed overlay.
    public init(viewModel: WomenCarePointHomeViewModelContract,
                @ViewBuilder top: () -> Top,
                @ViewBuilder content: () -> Content,
                @ViewBuilder bottom: () -> Bottom,
                @ViewBuilder error: () -> Error,
                @ViewBuilder overlay: () -> Overlay) {
        self.content = content()
        self.top = top()
        self.bottom = bottom()
        self.overlay = overlay()
        self.error = error()
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                top
                    .accessibilityFocused($isTitleFocused)
                ScrollView {
                    content
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(
                                        key: BottomSentinelMaxYPreferenceKey.self,
                                        value: proxy.frame(in: .named("WomenCarePointScroll")).maxY
                                    )
                            }
                        )
                }
                .scrollIndicators(.never)
                .coordinateSpace(name: "WomenCarePointScroll")
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                scrollViewHeight = geo.size.height
                            }
                            .onChange(of: geo.size.height) { _, new in
                                scrollViewHeight = new
                            }
                    }
                )
                .onPreferenceChange(BottomSentinelMaxYPreferenceKey.self) { maxY in
                    let margin = bottomDetectionMargin
                    let reached = maxY <= (scrollViewHeight + margin)
                    if reached != didReachBottom {
                        didReachBottom = reached
                    }
                }
                ZStack(alignment: .top) {
                    // Footer shadow
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(didReachBottom ? 0 : 0.1),
                            .clear
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 12)
                    .offset(y: -18)
                    bottom
                        .ignoresSafeArea(.all)
                }
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .hiddenOrRemoved(showError, remove: true)
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
        .onAppear {
            viewModel.notifyAppearance()
            if !showLoader {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isTitleFocused = true
                }
            }
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
        }
    }
}

private struct BottomSentinelMaxYPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .infinity
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = min(value, nextValue())
    }
}

private extension WomenCarePointHomeScreen {
    struct BackgroundView: View {
        var body: some View {
            Color.white
        }
    }
}
