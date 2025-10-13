//
//  WomenCarePointFooterSectionView.swift
//  MujerMadrid
//
//  Created by Javier Martin on 19/7/25.
//

import FComponents
import FNavigation
import SwiftUI

struct WomenCarePointHomeFooterSectionView: View {
    // MARK: Modular Variable
    let viewModel: WomenCarePointHomeFooterSectionViewModelContract
    
    // MARK: Environments & State
    
    // MARK: Life cycle
    init(viewModel: WomenCarePointHomeFooterSectionViewModelContract) {
        self.viewModel = viewModel
    }

    var body: some View {
        contentView
    }
}

// MARK: - Private UI

private extension WomenCarePointHomeFooterSectionView {

    @ViewBuilder
    var contentView: some View {
        ZStack(alignment: .top) {
            // --- Sombra difusa debajo del footer ---
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.1), // más opaco justo debajo del footer
                    .clear                    // difuminado hacia abajo
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 12) // controla el grosor/altura de la sombra
            .offset(y: -16)    // ajusta cuánto "sube" la sombra para pegarse al borde superior

            // --- Footer real ---
            HStack {
                Text("Servicio de atención gratuito a todas las formas de violencia contra las mujeres")
                    .font(.caption)
                button
            }
            .padding(.horizontal)
            .background(Color.white)
        }
    }

    @ViewBuilder
    var button: some View {
        let grad = LinearGradient(
            gradient: Gradient(colors: [Color(hex: "734aca"),
                                        Color(hex: "#9E67D5")]),
            startPoint: .leading,
            endPoint: .trailing
        )
        let configuration = FCButton.Configuration(label: "016",
                                                   leadingIcon: "phone.fill",
                                                   maxWidth: false,
                                                   invertCornerRadius: true)
        let viewState = FCButton.ViewState.enabled
        let variant = FCButton.Variant(type: .regularGradient(grad))
        let style = FCButton.Style(textColor: .white,
                                   leadingIconColor: .white,
                                   trailingIconColor: .white)
        let size = FCButton.Size.large
        let interaction = FCButton.Interaction(onTap: {
            viewModel.callNumber(number: "016")
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
