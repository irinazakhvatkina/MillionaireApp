import SwiftUI

@main
struct MillionaireApp: App {
    @StateObject private var gameVM = GameViewModel() 

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SecondView()
                    .environmentObject(gameVM)
            }
        }
    }
}
