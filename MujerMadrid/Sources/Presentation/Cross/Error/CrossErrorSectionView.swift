import Combine
import FComponents
import FNavigation
import FPresentation
import SwiftUI

struct CrossErrorSectionView: View {
    // MARK: - Modular Variable
    let viewModel: CrossErrorSectionViewModelContract

    // MARK: - State
    @SwiftUI.State private var isExpanded = false

    // MARK: - Life cycle
    /// Initializes the view with a view model.
    init(viewModel: CrossErrorSectionViewModelContract) {
        self.viewModel = viewModel
    }

    var body: some View {
        contentView
    }
}

// MARK: - Private UI
private extension CrossErrorSectionView {

    @ViewBuilder
    var contentView: some View {
        VStack(alignment: .center, spacing: 12) {
            Image("error_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .scaleEffect(isExpanded ? 1.1 : 0.9)
                .animation(
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true),
                    value: isExpanded
                )
            Text("No se ha podido cargar la información.")
                .font(.subheadline)
                .bold()
                .multilineTextAlignment(.center)
            Text("""
                 Puede que no tengas conexión a internet o que el servicio no esté disponible en este momento.
                 Por favor, revisa tu conexión e inténtalo de nuevo.
                 """)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            tryAgainButton
                .padding(.top)
        }
        .padding(.horizontal)
        .onAppear {
            isExpanded = true
        }
    }

    @ViewBuilder
    var tryAgainButton: some View {
        let grad = LinearGradient(
            gradient: Gradient(colors: [Color(hex: "734aca"),
                                        Color(hex: "9E67D5")]),
            startPoint: .leading,
            endPoint: .trailing
        )
        let configuration = FCButton.Configuration(label: "Intentar de nuevo",
                                                   maxWidth: false,
                                                   invertCornerRadius: true)
        let viewState = FCButton.ViewState.enabled
        let variant = FCButton.Variant(type: .regularGradient(grad))
        let style = FCButton.Style(textColor: .white)
        let size = FCButton.Size.medium
        let interaction = FCButton.Interaction(onTap: {
            viewModel.didTapTryAgain()
        })

        let viewModelButton = FCButton.ViewModel(configuration: configuration,
                                                 viewState: viewState,
                                                 variant: variant,
                                                 style: style,
                                                 size: size,
                                                 interaction: interaction)
        FCButton(viewModelButton)
    }
}
