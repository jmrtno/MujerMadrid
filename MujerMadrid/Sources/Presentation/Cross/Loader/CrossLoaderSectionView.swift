import Combine
import FPresentation
import SwiftUI

struct CrossLoaderSectionView: View {

    // MARK: Environments & State
    @State private var isExpanded = false

    var body: some View {
        loaderContainer
    }
}

// MARK: - Private UI
private extension CrossLoaderSectionView {
    @ViewBuilder var loaderContainer: some View {
        customLoader()
    }
    
    @ViewBuilder
    func customLoader() -> some View {
        ZStack {
            Color.white
            VStack {
                Image("icon_app")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .scaleEffect(isExpanded ? 1.1 : 0.9)
                    .animation(
                        .easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true),
                        value: isExpanded
                    )
                    .accessibilityHidden(true)
                Text("Cargando información")
                    .foregroundColor(.gray.opacity(1))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear {
            isExpanded = true
        }
    }
}
