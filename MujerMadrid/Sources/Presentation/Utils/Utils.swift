import SwiftUI

/// Utility functions for string formatting and text normalization
struct Utils {
    /// Capitalizes the first letter of a locality and removes parentheses
    /// - Parameter input: The input string representing a locality
    /// - Returns: Formatted locality string
    func formatLocality(_ input: String?) -> String {
        guard let input, !input.isEmpty else { return "" }
        
        let cleaned = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        
        return cleaned.prefix(1).capitalized + cleaned.dropFirst().lowercased()
    }
    
    /// Formats a street address according to capitalization rules
    /// - Parameter input: The street address
    /// - Returns: Properly formatted street address
    func formatStreetAddress(_ input: String?) -> String {
        guard let input, !input.isEmpty else { return "" }

        /// Special case for addresses starting with "reservada"
        if input.trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
                .hasPrefix("reservada") {
            return input
        }

        /// Words that should remain lowercase unless first word
        let lowercaseWords = [
            "de", "del", "la", "las", "el", "los", "y", "en", "a", "por", "con", "al"
        ]

        let words = input
            .lowercased()
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }

        let formattedWords = words.enumerated().map { index, word in
            if index == 0 || !lowercaseWords.contains(word) {
                return word.prefix(1).uppercased() + word.dropFirst()
            } else {
                return word
            }
        }

        return formattedWords.joined(separator: " ")
    }
    
    /// Normalizes spacing and punctuation in a text
    /// - Parameter text: Input string
    /// - Returns: Cleaned string
    func normalized(_ text: String) -> String {
        return text
            .replacingOccurrences(of: "\\s+([\\.\\:])", with: "$1", options: .regularExpression)
            .replacingOccurrences(of: "([\\.\\:])\\s+", with: "$1 ", options: .regularExpression)
            .replacingOccurrences(of: "\\s{2,}", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Color Extension

extension Color {
    /// Initialize Color from hex string (e.g., "#FF00AA" or "FF00AA")
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // skip leading "#"
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - View Extension

extension View {
    /// Conditionally hide or remove a view
    /// - Parameters:
    ///   - hide: If true, the view will be hidden
    ///   - remove: If true and hide is true, the view will be removed from the hierarchy
    @ViewBuilder
    @MainActor
    public func hiddenOrRemoved(_ hide: Bool, remove: Bool = false) -> some View {
        if hide {
            if remove {
                EmptyView()
            } else {
                self.hidden()
            }
        } else {
            self
        }
    }
}
