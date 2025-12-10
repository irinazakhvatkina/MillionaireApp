import SwiftUI
internal import Combine

class GameViewModel: ObservableObject {
    @Published var totalWinnings: Int = 0
    @Published var bestPrize: Int = UserDefaults.standard.integer(forKey: "bestPrize") {
        didSet { UserDefaults.standard.set(bestPrize, forKey: "bestPrize") }
    }
    
    @Published var currentLevel: Int = 0
    @Published var currentQuestionIndex: Int = 0
    @Published var remainingTime: Int = 30
    
    @Published var gameState: GameState = .notStarted
    
    // Добавим сохранение данных QuestionModel
    @Published var savedQuestionIndex: Int = 0
    @Published var savedTimeRemaining: Int = 30
    @Published var savedTotalWinnings: Int = 0
    @Published var savedRemovedAnswers: [Int] = []
    
    enum GameState {
        case notStarted, playing, paused, finished
    }
    
    var hasPausedGame: Bool {
        UserDefaults.standard.bool(forKey: "hasPausedGame")
    }

    func saveGame(questionModel: QuestionModel? = nil) {
        UserDefaults.standard.set(totalWinnings, forKey: "totalWinnings")
        UserDefaults.standard.set(currentLevel, forKey: "currentLevel")
        UserDefaults.standard.set(currentQuestionIndex, forKey: "currentQuestionIndex")
        UserDefaults.standard.set(remainingTime, forKey: "remainingTime")
        UserDefaults.standard.set(true, forKey: "hasPausedGame")
        
        // Сохраняем состояние QuestionModel
        if let questionModel = questionModel {
            UserDefaults.standard.set(questionModel.currentIndex, forKey: "savedQuestionIndex")
            UserDefaults.standard.set(questionModel.timeRemaining, forKey: "savedTimeRemaining")
            UserDefaults.standard.set(questionModel.totalWinnings, forKey: "savedTotalWinnings")
            
            // Сохраняем удаленные ответы
            let removedAnswersData = try? JSONEncoder().encode(questionModel.removedAnswerIndices)
            UserDefaults.standard.set(removedAnswersData, forKey: "savedRemovedAnswers")
        }
        
        gameState = .paused
        print("✅ Игра сохранена. Текущий вопрос: \(currentQuestionIndex)")
    }
    
    func resumeGame(questionModel: QuestionModel? = nil) {
        totalWinnings = UserDefaults.standard.integer(forKey: "totalWinnings")
        currentLevel = UserDefaults.standard.integer(forKey: "currentLevel")
        currentQuestionIndex = UserDefaults.standard.integer(forKey: "currentQuestionIndex")
        remainingTime = UserDefaults.standard.integer(forKey: "remainingTime")
        
        // Восстанавливаем состояние QuestionModel
        if let questionModel = questionModel {
            questionModel.currentIndex = UserDefaults.standard.integer(forKey: "savedQuestionIndex")
            questionModel.timeRemaining = UserDefaults.standard.integer(forKey: "savedTimeRemaining")
            questionModel.totalWinnings = UserDefaults.standard.integer(forKey: "savedTotalWinnings")
            
            // Восстанавливаем удаленные ответы (Set<Int>)
            if let removedAnswersData = UserDefaults.standard.data(forKey: "savedRemovedAnswers") {
                if let removedAnswersArray = try? JSONDecoder().decode([Int].self, from: removedAnswersData) {
                    questionModel.removedAnswerIndices = Set(removedAnswersArray)
                }
            }
        }
        
        gameState = .playing
        print("🔄 Игра восстановлена. Текущий вопрос: \(currentQuestionIndex)")
    }
    
    func startNewGame(questionModel: QuestionModel? = nil) {
        totalWinnings = 0
        currentLevel = 1
        currentQuestionIndex = 0
        remainingTime = 30
        
        // Сбрасываем состояние QuestionModel
        if let questionModel = questionModel {
            questionModel.currentIndex = 0
            questionModel.timeRemaining = 30
            questionModel.totalWinnings = 0
            questionModel.removedAnswerIndices = []
        }
        
        // Удаляем сохраненные данные
        UserDefaults.standard.removeObject(forKey: "hasPausedGame")
        UserDefaults.standard.removeObject(forKey: "savedQuestionIndex")
        UserDefaults.standard.removeObject(forKey: "savedTimeRemaining")
        UserDefaults.standard.removeObject(forKey: "savedTotalWinnings")
        UserDefaults.standard.removeObject(forKey: "savedRemovedAnswers")
        
        gameState = .playing
        print("🆕 Новая игра начата")
    }
    
    func finishGame() {
        gameState = .finished
        UserDefaults.standard.set(false, forKey: "hasPausedGame")
        if totalWinnings > bestPrize { bestPrize = totalWinnings }
    }
}
