import Combine
import FComponents
import FNavigation
import FPresentation
import MapKit
import SwiftUI

struct WomenCarePointHomeListSectionView: View {
    // MARK: - Modular Variable
    let viewModel: WomenCarePointHomeListSectionViewModelContract
    let publisher: AnyPublisher<WomenCarePointHomeListSectionRenderModel, Never>

    // MARK: - State
    @State private var renderModel = WomenCarePointHomeListSectionRenderModel.empty
    @State private var selectedMapItem: MKMapItem?
    @State private var mapItemToCenter: [MKMapItem: WomenCarePointHomeListSectionRenderModel.Centers] = [:]
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var hiddenCenter: WomenCarePointHomeListSectionRenderModel.Centers?

    // MARK: - Life cycle
    init(viewModel: WomenCarePointHomeListSectionViewModelContract,
         publisher: AnyPublisher<WomenCarePointHomeListSectionRenderModel, Never>) {
        self.viewModel = viewModel
        self.publisher = publisher
    }

    var body: some View {
        ScrollView {
            contentView
        }
        .onAppear {
            viewModel.getWomenCarePointInformationData()
        }
        .onReceive(publisher) { model in
            renderModel = model

            let visibles = model.centers.filter {
                $0.location.latitude != 0.0 && $0.location.longitude != 0.0
            }

            let items: [(MKMapItem, WomenCarePointHomeListSectionRenderModel.Centers)] = visibles.map { center in
                let coord = CLLocationCoordinate2D(
                    latitude: center.location.latitude,
                    longitude: center.location.longitude
                )
                let placemark = MKPlacemark(coordinate: coord)
                let item = MKMapItem(placemark: placemark)
                item.name = center.title
                return (item, center)
            }

            self.mapItemToCenter = Dictionary(uniqueKeysWithValues: items)

            self.hiddenCenter = model.centers.first {
                $0.location.latitude == 0.0 && $0.location.longitude == 0.0
            }

            if self.selectedMapItem == nil, let first = self.mapItemToCenter.keys.first {
                self.selectedMapItem = first
            }

            if !items.isEmpty {
                let avgLatitude = items.map { $0.0.placemark.coordinate.latitude }.reduce(0, +) / Double(items.count)
                let avgLongitude = items.map { $0.0.placemark.coordinate.longitude }.reduce(0, +) / Double(items.count)
                let centerCoordinate = CLLocationCoordinate2D(latitude: avgLatitude, longitude: avgLongitude)

                cameraPosition = .region(MKCoordinateRegion(
                    center: centerCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                ))
            }
        }
    }
}

// MARK: - Private UI
private extension WomenCarePointHomeListSectionView {
    var contentView: some View {
        VStack(alignment: .leading, spacing: 15) {
            if !renderModel.showList {
                mapView
                    .frame(height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                if let selected = selectedMapItem,
                   let center = mapItemToCenter[selected] {
                    getItemView(item: center)
                }
                if let hidden = hiddenCenter {
                    Text("\(hidden.title) (no visible en el mapa)")
                        .font(.headline)
                    getItemView(item: hidden)
                }
            } else {
                ForEach(renderModel.centers) { center in
                    getItemView(item: center)
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
            HStack {
                VStack {
                    Image("location_circle_invert")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Spacer()
                }
                VStack(alignment: .leading) {
                    if renderModel.showList {
                        Text(item.title)
                            .bold()
                        Text(item.streetAddress)
                            .bold()
                        Text("Horario de atención:")
                        Text(item.schedule)
                    } else {
                        Text(item.streetAddress)
                            .bold()
                        Text("Horario de atención:")
                        Text(item.schedule)
                    }
                }
                .font(.subheadline)
                Spacer()
                VStack {
                    Spacer()
                    Button(action: {
                        viewModel.navigateToCarePointDetail(centerId: item.id)
                    }, label: {
                        HStack(alignment: .center, spacing: 3) {
                            Text("Más")
                                .bold()
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(Color(hex: "734aca"))
                    })
                }
            }
            .padding()
        }
    }
}
