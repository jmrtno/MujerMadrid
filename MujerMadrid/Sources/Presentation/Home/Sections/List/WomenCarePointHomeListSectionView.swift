import Combine
import FComponents
import FNavigation
import FPresentation
import MapKit
import SwiftUI

/// View representing the Women Care Point Home List section.
/// Shows a map with centers and a list view depending on the render model.
struct WomenCarePointHomeListSectionView: View {
    // MARK: - Modular Variables
    let viewModel: WomenCarePointHomeListSectionViewModelContract
    let publisher: AnyPublisher<WomenCarePointHomeListSectionRenderModel, Never>

    // MARK: - State
    @State private var renderModel: WomenCarePointHomeListSectionRenderModel = .init()
    @State private var selectedMapItem: MKMapItem?
    @State private var mapItemToCenter: [MKMapItem: WomenCarePointHomeListSectionRenderModel.Centers] = [:]
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var hiddenCenter: WomenCarePointHomeListSectionRenderModel.Centers?
    @State private var isVoiceOverRunning = UIAccessibility.isVoiceOverRunning

    private var showHidden = true
    
    // MARK: - Life cycle
    init(viewModel: WomenCarePointHomeListSectionViewModelContract,
         publisher: AnyPublisher<WomenCarePointHomeListSectionRenderModel, Never>) {
        self.viewModel = viewModel
        self.publisher = publisher
    }

    var shouldShowList: Bool {
        renderModel.showList || isVoiceOverRunning
    }

    var body: some View {
        contentView
            .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.voiceOverStatusDidChangeNotification)) { _ in
                isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
            }
            .onReceive(publisher) { model in
                handleModelUpdate(model)
            }
    }
}

// MARK: - Private UI
private extension WomenCarePointHomeListSectionView {
    var contentView: some View {
        VStack(alignment: .leading, spacing: 15) {
            if shouldShowList {
                ForEach(renderModel.centers) { center in
                    getItemView(item: center)
                }
            } else {
                mapView
                    .frame(height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 30))

                if let selected = selectedMapItem,
                   let center = mapItemToCenter[selected] {
                    getItemView(item: center)
                }

                if let hidden = hiddenCenter {
                    Text("\(hidden.title) (no visible en el mapa)")
                        .font(.headline)
                        .foregroundStyle(.black)
                    getItemView(item: hidden)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }

    @ViewBuilder
    var mapView: some View {
        Map(position: $cameraPosition, selection: $selectedMapItem) {
            UserAnnotation()
            ForEach(Array(mapItemToCenter.keys), id: \.self) { item in
                if let center = mapItemToCenter[item] {
                    Marker(center.title,
                           systemImage: "building.2.crop.circle",
                           coordinate: item.placemark.coordinate)
                        .tint(Color(hex: "9E67D5"))
                }
            }
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
    }

    @ViewBuilder
    func getItemView(item: WomenCarePointHomeListSectionRenderModel.Centers) -> some View {
        FCCard(viewModel: .init(
            configuration: .init(doubleCard: false, maxWidth: true, contentAlignment: .leading),
            style: .init(innerCardBgColor: .white, innerCardBorderColor: Color.gray.opacity(0.3)),
            interaction: .init(onTap: {})
        )) {
            HStack {
                VStack {
                    Image("location_circle_invert")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .accessibilityHidden(true)
                    Spacer()
                }

                VStack(alignment: .leading) {
                    if shouldShowList {
                        Text(item.title).bold()
                        Text(item.streetAddress).bold()
                        Text("Horario de atención:")
                        Text(item.schedule)
                    } else {
                        Text(item.streetAddress).bold()
                        Text("Horario de atención:")
                        Text(item.schedule)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.black)

                Spacer()

                VStack {
                    Spacer()
                    Button(action: {
                        viewModel.navigateToCarePointDetail(centerData: item.eventData)
                    }, label: {
                        HStack(alignment: .center, spacing: 3) {
                            Text("Más").bold()
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(Color(hex: "734aca"))
                    })
                }
            }
            .accessibilityElement(children: .combine)
            .padding()
        }
    }
}

// MARK: - Private Methods

private extension WomenCarePointHomeListSectionView {
    func handleModelUpdate(_ model: WomenCarePointHomeListSectionRenderModel) {
        renderModel = model

        let visibles = model.centers.filter { $0.location.latitude != 0.0 && $0.location.longitude != 0.0 }

        let items: [(MKMapItem, WomenCarePointHomeListSectionRenderModel.Centers)] = visibles.map { center in
            let coord = CLLocationCoordinate2D(latitude: center.location.latitude,
                                               longitude: center.location.longitude)
            let placemark = MKPlacemark(coordinate: coord)
            let item = MKMapItem(placemark: placemark)
            item.name = center.title
            return (item, center)
        }

        mapItemToCenter = Dictionary(uniqueKeysWithValues: items)
        hiddenCenter = model.centers.first { $0.location.latitude == 0.0 && $0.location.longitude == 0.0 }

        if selectedMapItem == nil || (selectedMapItem != nil && !mapItemToCenter.keys.contains(selectedMapItem!)) {
            selectedMapItem = mapItemToCenter.keys.first
        }

        if !items.isEmpty {
            let avgLatitude = items.map { $0.0.placemark.coordinate.latitude }.reduce(0, +) / Double(items.count)
            let avgLongitude = items.map { $0.0.placemark.coordinate.longitude }.reduce(0, +) / Double(items.count)
            let centerCoordinate = CLLocationCoordinate2D(latitude: avgLatitude, longitude: avgLongitude)

            cameraPosition = .region(MKCoordinateRegion(center: centerCoordinate,
                                                        span: MKCoordinateSpan(latitudeDelta: 0.2,
                                                                               longitudeDelta: 0.2)))
        }
    }
}

