import SwiftUI

struct ExpandableText: View {
    let content: String

    @State private var expanded = false
    @State private var isTruncatable = false

    var body: some View {
        expandedText(text: content)
    }

    @ViewBuilder
    private func expandedText(text: String) -> some View {
        VStack(alignment: .leading) {
            Text(text)
                .foregroundStyle(.black)
                .lineLimit(expanded ? nil : 4)
                .background(
                    TextHeightReader(text: text, lineLimit: 4) { exceeds in
                        isTruncatable = exceeds
                    }
                    .hidden()
                )

            if isTruncatable {
                Text(expanded ? "Menos" : "Más")
                    .foregroundColor(.blue)
                    .font(.caption)
                    .onTapGesture {
                        expanded.toggle()
                    }
            }
        }
    }
    
    struct TextHeightReader: View {
        let text: String
        let lineLimit: Int
        let callback: (Bool) -> Void

        var body: some View {
            Text(text)
                .lineLimit(nil)
                .background(
                    GeometryReader { fullGeometry in
                        Color.clear
                            .preference(key: TextHeightPreferenceKey.self,
                                        value: fullGeometry.size.height)
                    }
                )
                .hidden()
                .onPreferenceChange(TextHeightPreferenceKey.self) { fullHeight in
                    let lineHeight: CGFloat = UIFont.preferredFont(forTextStyle: .body).lineHeight
                    let maxHeight = CGFloat(lineLimit) * lineHeight
                    Task { @MainActor in
                        callback(fullHeight > maxHeight)
                    }
                }
        }
    }

    struct TextHeightPreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = .zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}
