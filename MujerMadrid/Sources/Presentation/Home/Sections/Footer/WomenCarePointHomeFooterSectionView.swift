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
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.1),
                    .clear
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 12)
            .offset(y: -16)

            HStack {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    /// iPad alternative view
                    Text("Servicio de atención gratuito a todas las formas de violencia de género: 016")
                        .font(.caption)
                        .foregroundStyle(.black)
                        .padding()
                } else {
                    Text("Servicio de atención gratuito a todas las formas de violencia de género")
                        .font(.caption)
                        .foregroundStyle(.black)
                    button
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(.white)
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

#Preview {
    struct MockViewModel: WomenCarePointHomeFooterSectionViewModelContract {
        func callNumber(number: String) {
            print("Se intentaría llamar al número: \(number)")
        }
    }

    return WomenCarePointHomeFooterSectionView(viewModel: MockViewModel())
}
