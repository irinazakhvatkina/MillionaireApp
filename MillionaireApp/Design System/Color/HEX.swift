import SwiftUI

extension Color {
    init(hex: String) {
        var hex = hex
        if hex.hasPrefix("#") { hex.removeFirst() }

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 8:
            a = (int >> 24) & 0xff
            r = (int >> 16) & 0xff
            g = (int >> 8) & 0xff
            b = int & 0xff
        case 6:
            a = 255
            r = (int >> 16) & 0xff
            g = (int >> 8) & 0xff
            b = int & 0xff
        default:
            a = 255; r = 0; g = 0; b = 0
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
