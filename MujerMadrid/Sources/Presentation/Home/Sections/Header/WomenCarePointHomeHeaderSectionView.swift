import FComponents
import FNavigation
import SwiftUI

struct WomenCarePointHomeHeaderSectionView: View {
    // MARK: Modular Variable
    let viewModel: WomenCarePointHomeHeaderSectionViewModelContract
    
    // MARK: Environments & State
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass

    @State private var isOn = false
    
    @State private var isVoiceOverRunning = UIAccessibility.isVoiceOverRunning
    
    // MARK: Life cycle
    
    /// Initializes the view with the provided view model.
    init(viewModel: WomenCarePointHomeHeaderSectionViewModelContract) {
        self.viewModel = viewModel
    }

    var body: some View {
        contentView
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
            .padding(.horizontal, 7)
            if !isVoiceOverRunning {
                toogleButton
            }
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
}

#Preview {
    struct MockViewModel: WomenCarePointHomeHeaderSectionViewModelContract {
        func didTapToggle() {
            print("Se pulsa el boton toggle")
        }
    }
    return WomenCarePointHomeHeaderSectionView(viewModel: MockViewModel())
}
