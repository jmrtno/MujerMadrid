//
//  WomenCarePointDetailScreen.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

import FComponents
import FDependencyInjector
import FPresentation
import SwiftUI

public struct WomenCarePointDetailScreen<Top: View,
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
                .hiddenOrRemoved(showError, remove: true)
            VStack {
                ScrollView {
                    content
                }
                bottom
            }
            .hiddenOrRemoved(showError, remove: true)
            .background(Color.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            .padding(.top, viewModel.paddingSize)
            .ignoresSafeArea(edges: .bottom)
            if showError {
                error
            }
            if showLoader {
                overlay
            }
        }
        .onAppear {
            viewModel.notifyAppearance()
        }
        .onReceive(viewModel.errorPublisher) {
            showError = $0
        }
        .onReceive(viewModel.loaderPublisher) {
            showLoader = $0
        }
    }
}

private extension WomenCarePointDetailScreen {

}
