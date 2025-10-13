//
//  WomenCarePointHomeScreen.swift
//  MujerMadrid
//
//  Created by Javier Martin on 17/7/25.
//

import FComponents
import FDependencyInjector
import FPresentation
import SwiftUI

public struct WomenCarePointHomeScreen<Top: View,
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

    @SwiftUI.State private var viewSize: CGSize = .zero
    @SwiftUI.State private var showError = false
    @SwiftUI.State private var showLoader = false

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
                content
                bottom
            }
            .hiddenOrRemoved(showError, remove: true)
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

private extension WomenCarePointHomeScreen {
    struct BackgroundView: View {
        var body: some View {
            Color.white
        }
    }
}
