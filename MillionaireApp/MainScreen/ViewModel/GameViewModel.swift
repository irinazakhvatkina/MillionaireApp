import SwiftUI
internal import Combine

class GameViewModel: ObservableObject {
    @Published var totalWinnings: Int = 0
    @Published var bestPrize: Int = UserDefaults.standard.integer(forKey: "bestPrize") {
        didSet {
            UserDefaults.standard.set(bestPrize, forKey: "bestPrize")
        }
    }
    
    @Published var gameState: GameState = .notStarted
    @Published var currentLevel: Int = 0
    
    enum GameState {
        case notStarted
        case playing
        case finished
    }
    
    func startNewGame() {
        totalWinnings = 0
        currentLevel = 1
        gameState = .playing
    }
    
    func goToNextLevel(withReward reward: Int) {
        totalWinnings += reward
        currentLevel += 1
        
        if totalWinnings > bestPrize {
            bestPrize = totalWinnings
        }
    }
    
    func finishGame() {
        gameState = .finished
    }
    
    func resetGame() {
        totalWinnings = 0
        currentLevel = 0
        gameState = .notStarted
    }
    
    // Пример логики расчета награды за уровень
    func rewardForLevel(_ level: Int) -> Int {
        switch level {
        case 1...5: return 1000
        case 6...10: return 5000
        case 11...15: return 15000
        default: return 25000
        }
    }
}
