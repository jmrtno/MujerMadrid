import Combine
import FComponents
import FNavigation
import FPresentation
@preconcurrency import MapKit
import SwiftUI

struct WomenCarePointDetailContentSectionView: View {
    // MARK: Modular Variable
    let viewModel: WomenCarePointDetailContentSectionViewModelContract
    let publisher: AnyPublisher<WomenCarePointDetailContentSectionRenderModel, Never>
    
    // MARK: Environments & State
    @SwiftUI.State private var renderModel: WomenCarePointDetailContentSectionRenderModel = .init()
    @SwiftUI.State private var route: MKRoute?

    
    // MARK: Life cycle
    
    /// Initializes the section view with a view model and publisher.
    init(viewModel: WomenCarePointDetailContentSectionViewModelContract,
         publisher: AnyPublisher<WomenCarePointDetailContentSectionRenderModel, Never>) {
        self.viewModel = viewModel
        self.publisher = publisher
    }

    var body: some View {
        contentView
            .onReceive(publisher) {
                renderModel = $0
            }
    }
}

// MARK: - Private UI

private extension WomenCarePointDetailContentSectionView {
    @ViewBuilder
    private var contentView: some View {
        VStack(alignment: .center, spacing: 15) {
            centerInfo(icon: "info.circle.fill", title: "Descripción del centro",
                 content: renderModel.center.description)
            centerInfo(icon: "checkmark.circle.fill", title: "Servicios",
                       content: renderModel.center.services)
            if hasValidCoordinates {
                showMapButton
            } else {
                noMapCard
            }
            schedule
        }
        .padding()
    }
    
    private func centerInfo(icon: String, title: String, content: String) -> some View {
        FCCard(viewModel: .init(
            configuration: .init(
                doubleCard: false,
                maxWidth: true,
                contentAlignment: .leading
            ),
            style: .init(
                innerCardBgColor: .white,
                innerCardBorderColor: Color.gray.opacity(0.3)
            ),
            interaction: .init(onTap: {})
        )) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 25, weight: .regular))
                        .foregroundColor(Color(hex: "9E67D5"))
                    Text(title)
                        .font(.title3)
                        .foregroundStyle(.black)
                        .bold()
                }
                .padding(.bottom, 4)
                ExpandableText(content: content)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var showMapButton: some View {
        let grad = LinearGradient(
            gradient: Gradient(colors: [Color(hex: "734aca"),
                                        Color(hex: "9E67D5")]),
            startPoint: .leading,
            endPoint: .trailing
        )
        let configuration = FCButton.Configuration(label: "Cómo llegar",
                                                   leadingIcon: "location",
                                                   maxWidth: true,
                                                   invertCornerRadius: true)
        let viewState = FCButton.ViewState.enabled
        let variant = FCButton.Variant(type: .regularGradient(grad))
        let style = FCButton.Style(textColor: .white,
                                   leadingIconColor: .white)
        let size = FCButton.Size.large
        let interaction = FCButton.Interaction(onTap: {
            viewModel.navigateTo(latitud: renderModel.center.location.latitude,
                                 longitud: renderModel.center.location.longitude)
        })

        let viewModelButton = FCButton.ViewModel(configuration: configuration,
                                                 viewState: viewState,
                                                 variant: variant,
                                                 style: style,
                                                 size: size,
                                                 interaction: interaction)
        FCButton(viewModelButton)
    }

    private var noMapCard: some View {
        FCCard(viewModel: .init(
            configuration: .init(
                doubleCard: false,
                maxWidth: true,
                contentAlignment: .leading
            ),
            style: .init(
                innerCardBgColor: Color(hex: "9E67D5"),
                innerCardBorderColor: Color.gray.opacity(0.3)
            ),
            interaction: .init(onTap: {})
        )) {
            Text("Ubicación no especificada")
                .foregroundStyle(.white)
                .padding()
        }
    }

    private var hasValidCoordinates: Bool {
        renderModel.center.location.latitude != 0 && renderModel.center.location.longitude != 0
    }

    @ViewBuilder
    private var schedule: some View {
        let postalCode: String = {
            if !renderModel.center.postalCode.isEmpty || hasValidCoordinates {
                return "\(renderModel.center.postalCode), "
            }
            return ""
        }()

        FCCard(viewModel: .init(
            configuration: .init(
                doubleCard: false,
                maxWidth: true,
                contentAlignment: .leading
            ),
            style: .init(
                innerCardBgColor: .white,
                innerCardBorderColor: Color.gray.opacity(0.3)
            ),
            interaction: .init(onTap: {})
        )) {
            VStack(alignment: .leading) {
                HStack {
                    Image("location_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.black.opacity(0.7))
                    Text("\(renderModel.center.streetAddress), \(postalCode)\(renderModel.center.locality)")
                        .font(.subheadline)
                        .foregroundStyle(.black)
                }
                .padding(.bottom, 4)
                
                Divider()
                
                HStack {
                    Image("clock_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.black.opacity(0.7))
                    Text(renderModel.center.schedule)
                        .font(.subheadline)
                        .foregroundStyle(.black)
                }
                .padding(.bottom, 4)
            }
            .padding()
        }
    }
}

private extension WomenCarePointDetailContentSectionView {
    func calculateDirections(sourceCoordinate: CLLocationCoordinate2D,
                             destinationCoordinate: CLLocationCoordinate2D) async {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.transportType = .walking

        let response = try? await MKDirections(request: request).calculate()
        route = response?.routes.first
    }
}
