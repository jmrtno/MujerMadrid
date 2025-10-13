//
//  Utils.swift
//  MujerMadrid
//
//  Created by Javier Martin on 23/7/25.
//
import SwiftUI

public struct Utils {
    func formatLocality(_ input: String?) -> String {
        guard let input, !input.isEmpty else { return "" }
        
        // Elimina paréntesis y espacios, ejemplo: "(MADRID)" -> "MADRID"
        let cleaned = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        
        // Capitaliza solo la primera letra
        return cleaned.prefix(1).capitalized + cleaned.dropFirst().lowercased()
    }
    
    func formatStreetAddress(_ input: String?) -> String {
        guard let input, !input.isEmpty else { return "" }

        // Si la dirección empieza por "Reservada", devolverla tal como viene
        if input.trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
                .hasPrefix("reservada") {
            return input
        }

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
    
    func normalized(_ text: String) -> String {
        return text
            .replacingOccurrences(of: "\\s+([\\.\\:])", with: "$1", options: .regularExpression) // elimina espacios antes de "." y ":"
            .replacingOccurrences(of: "([\\.\\:])\\s+", with: "$1 ", options: .regularExpression) // deja solo un espacio después de "." y ":"
            .replacingOccurrences(of: "\\s{2,}", with: " ", options: .regularExpression) // cualquier espacio doble o más, lo deja en uno solo
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

extension View {
    /// Hide view and optionally remove it from the hierarchy.
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
