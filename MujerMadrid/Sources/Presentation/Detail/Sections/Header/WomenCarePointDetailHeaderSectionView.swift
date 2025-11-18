//
//  WomenCarePointDetailHeaderSectionView.swift
//  MujerMadrid
//
//  Created by Javier Martin on 18/7/25.
//


import Combine
import FComponents
import FNavigation
import FPresentation
import SwiftUI

struct WomenCarePointDetailHeaderSectionView: View {
    // MARK: Modular Variable
    let viewModel: WomenCarePointDetailHeaderSectionViewModelContract
    let publisher: AnyPublisher<WomenCarePointDetailHeaderSectionRenderModel, Never>
    
    // MARK: Environments & State
    @SwiftUI.State private var renderModel: WomenCarePointDetailHeaderSectionRenderModel = .init()
    
    // MARK: Life cycle
    init(viewModel: WomenCarePointDetailHeaderSectionViewModelContract,
         publisher: AnyPublisher<WomenCarePointDetailHeaderSectionRenderModel, Never>) {
        self.viewModel = viewModel
        self.publisher = publisher
    }

    var body: some View {
        contentView
            .onReceive(publisher) {
                self.renderModel = $0
            }
    }
}

// MARK: - Private UI

private extension WomenCarePointDetailHeaderSectionView {
    var contentView: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "9E67D5"),
                                            Color(hex: "734aca")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
            
            VStack(spacing: 12) {
                backButton
                    .frame(maxWidth: .infinity, alignment: .leading)
                iconAndTitle
                centerType
                Spacer()
            }
            .padding(.horizontal)
        }
        .frame(height: viewModel.headerHeight)
    }

    var backButton: some View {
        Button {
            viewModel.goBack()
        } label: {
            Image(systemName: "arrow.backward")
                .foregroundColor(.white)
        }
    }

    var iconAndTitle: some View {
        HStack(spacing: 12) {
            Image("location_circle")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            Text(renderModel.title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var centerType: some View {
        Text(renderModel.centerType)
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.2))
            .cornerRadius(20)
            .foregroundColor(.white)
    }
}
