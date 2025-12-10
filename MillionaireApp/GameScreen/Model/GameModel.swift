import SwiftUI
internal import Combine

// MARK: - Models

struct Question: Codable, Identifiable {
    var id = UUID()
    var question: String
    var answers: [String]
    let correct: Int
    let difficulty: String
    
    enum CodingKeys: String, CodingKey {
        case question, answers, correct, difficulty
    }
}

struct QuestionWrapper: Codable {
    let questions: [Question]
}


// MARK: - ViewModel

class QuestionModel: ObservableObject {
    
    // MARK: Published Properties
    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var score: Int = 0
    
    @Published var totalWinnings: Int = 0
    @Published var guaranteedWinnings: Int = 0
    
    @Published var showResult: Bool = false
    @Published var timeRemaining: Int = 30
    
    @Published var used5050: Bool = false
    @Published var usedAudience: Bool = false
    @Published var usedPhone: Bool = false
    @Published var removedAnswerIndices: Set<Int> = []
    
    @Published var bestPrize: Int = UserDefaults.standard.integer(forKey: "bestPrize") {
        didSet { UserDefaults.standard.set(bestPrize, forKey: "bestPrize") }
    }
    
    // MARK: Prize levels
    let prizeLevels: [Int] = [
        500, 1_000, 2_000, 3_000, 5_000,
        7_500, 10_000, 12_500, 15_000,
        25_000, 50_000, 100_000,
        250_000, 500_000, 1_000_000
    ]
    
    let guaranteedIndices: Set<Int> = [4, 9]
    
    private var timerCancellable: AnyCancellable?
    
    
    // MARK: Init
    init() {
        loadQuestions()
    }
    
    
    // MARK: Load Questions
    private func loadQuestions() {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            print("❌ questions.json NOT FOUND")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(QuestionWrapper.self, from: data)
            self.questions = decoded.questions
            print("📘 Loaded questions: \(questions.count)")
        } catch {
            print("❌ Decode Error:", error)
        }
    }
    
    
    // MARK: Check Answer
    func checkAnswer(_ index: Int) {
        guard currentIndex < questions.count else { return }
        
        stopTimer()
        
        let question = questions[currentIndex]
        
        if index == question.correct {
            score += 1
            awardPrizeForCurrentQuestion()
            updateGuaranteedIfNeeded()
            updateBestPrize()
            nextQuestion()
        } else {
            totalWinnings = max(totalWinnings, guaranteedWinnings)
            updateBestPrize()
            finishGame()
        }
    }
    
    
    // MARK: Update best record
    func updateBestPrize() {
        if totalWinnings > bestPrize {
            bestPrize = totalWinnings
        }
    }
    
    var isNewRecord: Bool {
        totalWinnings > UserDefaults.standard.integer(forKey: "bestPrize")
    }
    
    
    // MARK: Prize Logic
    func awardPrizeForCurrentQuestion() {
        totalWinnings = prizeForQuestion(index: currentIndex)
    }
    
    func prizeForQuestion(index: Int) -> Int {
        prizeLevels[min(index, prizeLevels.count - 1)]
    }
    
    private func updateGuaranteedIfNeeded() {
        if guaranteedIndices.contains(currentIndex) {
            guaranteedWinnings = prizeForQuestion(index: currentIndex)
        }
    }
    
    
    // MARK: Navigation Logic
    private func nextQuestion() {
        if currentIndex + 1 < questions.count {
            currentIndex += 1
            removedAnswerIndices.removeAll()
            startTimer()
        } else {
            finishGame()
        }
    }
    
    private func finishGame() {
        stopTimer()
        showResult = true
    }
    
    
    // MARK: Timer Logic
    func startTimer() {
        stopTimer()
        timeRemaining = 30
        
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                
                timeRemaining -= 1
                
                if timeRemaining <= 0 {
                    totalWinnings = max(totalWinnings, guaranteedWinnings)
                    finishGame()
                }
            }
    }
    
    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    
    // MARK: Lifelines
    func use5050() -> Set<Int> {
        guard !used5050,
              currentIndex < questions.count else { return [] }
        
        used5050 = true
        removedAnswerIndices.removeAll()
        
        let correct = questions[currentIndex].correct
        let wrong = (0..<questions[currentIndex].answers.count).filter { $0 != correct }
        
        removedAnswerIndices = Set(wrong.shuffled().prefix(2))
        return removedAnswerIndices
    }
    
    
    func askAudience() -> [Int] {
        guard !usedAudience,
              currentIndex < questions.count else { return [] }
        
        usedAudience = true
        
        let correct = questions[currentIndex].correct
        let count = questions[currentIndex].answers.count
        
        var weights = Array(repeating: 0, count: count)
        weights[correct] = 50
        
        var remaining = 50
        let wrongIndices = (0..<count).filter { $0 != correct }
        
        for i in wrongIndices.dropLast() {
            let value = Int.random(in: 0...remaining)
            weights[i] = value
            remaining -= value
        }
        if let last = wrongIndices.last {
            weights[last] = remaining
        }
        
        return weights
    }
    
    
    func phoneAFriend() -> (suggestion: Int, confidence: Int)? {
        guard !usedPhone,
              currentIndex < questions.count else { return nil }
        
        usedPhone = true
        
        let correct = questions[currentIndex].correct
        let count = questions[currentIndex].answers.count
        
        let difficulty = questions[currentIndex].difficulty.lowercased()
        
        let accuracy =
            difficulty == "easy" ? 85 :
            difficulty == "medium" ? 65 :
            difficulty == "hard" ? 45 : 60
        
        if Int.random(in: 1...100) <= accuracy {
            return (correct, Int.random(in: 60...95))
        }
        
        let wrong = (0..<count).filter { $0 != correct }
        return (wrong.randomElement() ?? correct, Int.random(in: 30...70))
    }
    
    
    // MARK: Reset Game
    func resetGame() {
        currentIndex = 0
        score = 0
        totalWinnings = 0
        guaranteedWinnings = 0
        showResult = false
        timeRemaining = 30
        used5050 = false
        usedAudience = false
        usedPhone = false
        removedAnswerIndices.removeAll()
        startTimer()
    }
}


// MARK: - Timer UI

struct TimerBarView: View {
    @Binding var timeRemaining: Int
    let totalTime: Int
    let height: CGFloat
    
    var body: some View {
        Text("\(timeRemaining)")
            .font(.system(size: height * 0.9, weight: .bold))
            .foregroundColor(timeRemaining <= 7 ? .red1 :
                             timeRemaining <= 15 ? .yellow2 : .white)
    }
}
