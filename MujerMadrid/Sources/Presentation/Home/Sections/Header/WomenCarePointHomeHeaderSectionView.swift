import Combine
import FComponents
import FNavigation
import SwiftUI

struct WomenCarePointHomeHeaderSectionView: View {
    // MARK: Modular Variable
    let viewModel: WomenCarePointHomeHeaderSectionViewModelContract
    
    // MARK: Environments & State
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass

    @State private var pickerFilters: PickerFilter = .all
    @State private var isOn = false
    @State private var isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
    
    
    // MARK: Life cycle
    
    /// Initializes the view with the provided view model.
    init(viewModel: WomenCarePointHomeHeaderSectionViewModelContract) {
        self.viewModel = viewModel
    }

    var body: some View {
        contentView
            .onReceive(Just(pickerFilters)) { value in
                viewModel.filterSelected(filter: value.rawValue)
            }
            .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.voiceOverStatusDidChangeNotification)) { _ in
                isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
            }
    }
}

// MARK: - Private UI

private extension WomenCarePointHomeHeaderSectionView {
    @ViewBuilder
    var contentView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Image("icon_app")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 65, height: 65)
                    .accessibilityHidden(true)
                VStack(alignment: .leading) {
                    Text("Mujer Madrid")
                        .font(.title)
                        .foregroundStyle(.black)
                        .bold()
                    Text("Información y acceso rápido a centros de atención a mujeres")
                        .font(.subheadline)
                        .foregroundStyle(.black)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                }
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)
            }
            .padding(.horizontal, 5)
            if !isVoiceOverRunning {
                toogleButton
            }
            filters
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, verticalSizeClass == .compact ? 12 : 0)
    }

    @ViewBuilder
    var toogleButton: some View {
        Toggle(isOn: $isOn) {
            Text("Mostrar como lista")
                .font(.subheadline)
                .foregroundStyle(.black)
        }
        .padding(.horizontal, 16)
        .colorScheme(.light)
        .onChange(of: isOn) {
            viewModel.didTapToggle()
        }
    }
    
    @ViewBuilder
    var filters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(PickerFilter.allCases, id: \.self) { filter in
                    let configuration = FCPill.Configuration(text: filter.filterName)
                    let viewState = FCPill.ViewState.enabled
                    let style = FCPill.Style()
                    let interaction = FCPill.Interaction(onTap: {
                        pickerFilters = filter
                    })
                    let FCPillViewModel = FCPill.ViewModel(configuration: configuration,
                                                           viewState: viewState,
                                                           variant: .secondary(textAndBorderColor: Color(hex: "734aca"),
                                                                               backgroundColor: Color(hex: "734aca")),
                                                           style: style,
                                                           size: .medium,
                                                           interaction: interaction)

                    FCPill(viewModel: FCPillViewModel, isSelected: Binding(
                        get: { pickerFilters == filter },
                        set: { _ in pickerFilters = filter }
                    ))
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
    }
}

private extension WomenCarePointHomeHeaderSectionView {
    enum PickerFilter: String, CaseIterable, Identifiable {
        case all
        case social
        case jur
        case psicol
        case profes

        var id: Self { self }

        var filterName: String {
            switch self {
            case .all:
                return "Todos"
            case .social:
                return "Atención Social"
            case .jur:
                return "Atención Jurídica"
            case .psicol:
                return "Atención Psicológica"
            case .profes:
                return "Desarrollo Profesional"
            }
        }
    }
}

#Preview {
    struct MockViewModel: WomenCarePointHomeHeaderSectionViewModelContract {
        func filterSelected(filter: String) {
            print("Se pulsa un filtro")
        }
        
        func didTapToggle() {
            print("Se pulsa el boton toggle")
        }
    }
    return WomenCarePointHomeHeaderSectionView(viewModel: MockViewModel())
}
