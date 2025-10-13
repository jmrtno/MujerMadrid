//
//  WomenCarePointHomeHeaderSectionView.swift
//  CercaDeTi
//
//  Created by Javier Martin on 13/10/25.
//

import FComponents
import FNavigation
import SwiftUI

struct WomenCarePointHomeHeaderSectionView: View {
    // MARK: Modular Variable
    let viewModel: WomenCarePointHomeHeaderSectionViewModelContract
    
    // MARK: Environments & State
    @State private var isOn = false
    
    // MARK: Life cycle
    init(viewModel: WomenCarePointHomeHeaderSectionViewModelContract) {
        self.viewModel = viewModel
    }

    var body: some View {
        contentView
    }
}

// MARK: - Private UI

private extension WomenCarePointHomeHeaderSectionView {
    @ViewBuilder
    var contentView: some View {
        VStack(alignment: .leading) {
            Text("Centros de atención a la mujer")
                .font(.title)
                .bold()
            HStack {
                Text("Encuentra tu centro más cercano")
                    .font(.subheadline)
                toogleButton
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    var toogleButton: some View {
        Toggle(isOn: $isOn) {
            Text("Mostrar lista")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .onChange(of: isOn) {
            viewModel.didTapToggle()
        }
    }
}
