import SwiftUI

enum Gradients {
//    active button
    static let goldButton = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#E1CF30"),
            Color(hex: "#E19A30"),
            Color(hex: "#E19A30"),
            Color(hex: "#E1CF30")
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
//    inactive button
    static let blueDeepButton = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#025D83"),
            Color(hex: "#022B54"),
            Color(hex: "#020631"),
            Color(hex: "#083C66")
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
//    correct answer
    static let greenButton = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#3B8E14"),
            Color(hex: "#266608"),
            Color(hex: "#266608"),
            Color(hex: "#3D881A")
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
//    wrong answer
    static let redButton = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#B4411C"),
            Color(hex: "#832102"),
            Color(hex: "#832102"),
            Color(hex: "#B43E19")
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
//    non-withdrawable amount
    static let skyBlueButton = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#60C3FB"),
            Color(hex: "#1180BF"),
            Color(hex: "#1D88C5"),
            Color(hex: "#26A6EE")
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

}

