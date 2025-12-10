import SwiftUI

@main
struct MillionaireApp: App {
    @StateObject private var gameVM = GameViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if gameVM.currentLevel == 0 {
                    HomeView()
                        .environmentObject(gameVM)
                } else {
                    GameView()
                        .environmentObject(gameVM)
                }
            }
        }
    }
}
