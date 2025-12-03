import SwiftUI

enum ButtonColor {
    case blueButton
    case yellowButton
    case redButton
    case greenButton
    case lightBlueButton
    
    var colors: [Color] {
        switch self {
        case .blueButton: return [ .blue1, .blue2, .blue3, .blue4]
        case .yellowButton: return [ .yellow1, .yellow2, .yellow2, .yellow1]
        case .redButton: return [ .red1, .red2, .red2, .red3]
        case .greenButton: return [ .green1, .green2, .green2, .green3]
        case .lightBlueButton: return [.lightBlue1, .lightBlue2, .lightBlue3, .lightBlue4]
        }
    }
}

