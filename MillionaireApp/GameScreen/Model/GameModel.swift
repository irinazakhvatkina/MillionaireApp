import SwiftUI
internal import Combine

struct Question: Codable, Identifiable {
    var id = UUID()  
    var question: String
    var answers: [String]
    let correct: Int
    let difficulty: String
    
    private enum CodingKeys: String, CodingKey {
        case question, answers, correct, difficulty
    }
}

struct QuestionWrapper: Codable {
    let questions: [Question]
}


class QuestionModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentIndex = 0
    @Published var score = 0
    @Published var showResult = false
    
    @Published var totalWinnings: Int = 0
    @Published var guaranteedWinnings: Int = 0
    @Published var timeRemaining: Int = 30
    
    @Published var used5050: Bool = false
    @Published var usedAudience: Bool = false
    @Published var usedPhone: Bool = false
    
    @Published var removedAnswerIndices: Set<Int> = []
    
    func use5050() -> Set<Int> {
        guard !used5050, currentIndex < questions.count else { return  [] }
        used5050 = true
        removedAnswerIndices.removeAll()
        
        let correct = questions[currentIndex].correct
        let allIndices = Array(0..<questions[currentIndex].answers.count)
        let wrongIndices = allIndices.filter { $0 != correct }
        let toRemove = Array(wrongIndices.shuffled().prefix(min(2, wrongIndices.count)))
        
        removedAnswerIndices = Set(toRemove)
        return  removedAnswerIndices
    }
    
    func askAudience() -> [Int] {
        guard !usedAudience, currentIndex < questions.count else { return [] }
        usedAudience = true
        
        let correct = questions[currentIndex].correct
        let count = questions[currentIndex].answers.count
        
        let baseCorrectWeight = 51
        let remaining = 100 - baseCorrectWeight
        var weights = Array(repeating: 0, count: count)
        weights[correct] = baseCorrectWeight
        
        let wrongIndices = (0..<count).filter { $0 != correct }
        var remainingWeights = remaining
        for i in 0..<wrongIndices.count {
            if i == wrongIndices.count - 1 {
                weights[wrongIndices[i]] = remainingWeights
            } else {
                let share = Int.random(in: 0...remainingWeights)
                weights[wrongIndices[i]] = share
                remainingWeights -= share
            }
        }
        let sum = weights.reduce(0, +)
        if sum != 100 {
            let diff = 100 - sum
            weights[correct] += diff
        }
        
        return weights
    }
    func phoneAFriend() -> (suggestion: Int, confidence: Int)? {
        guard !usedPhone, currentIndex < questions.count else { return nil }
        usedPhone = true

        let correct = questions[currentIndex].correct
        let count = questions[currentIndex].answers.count

        // Friend accuracy depends on difficulty (if you have it)
        let difficulty = questions[currentIndex].difficulty.lowercased()
        let baseAccuracy: Int
        switch difficulty {
        case "easy": baseAccuracy = 85
        case "medium": baseAccuracy = 65
        case "hard": baseAccuracy = 45
        default: baseAccuracy = 60
        }

        let roll = Int.random(in: 1...100)
        if roll <= baseAccuracy {
            // friend picks correct
            let confidence = Int.random(in: max(60, baseAccuracy-10)...min(95, baseAccuracy+10))
            return (correct, confidence)
        } else {
            // friend picks a wrong answer
            let wrongIndices = (0..<count).filter { $0 != correct }
            guard let pick = wrongIndices.randomElement() else { return (correct, 50) }
            let confidence = Int.random(in: 30...70)
            return (pick, confidence)
        }
    }



    
    private var timerCancellable: AnyCancellable?
    let prizeLevels: [Int] = [ 500, 1_000, 2_000, 3_000, 5_000,
                               7_500, 10_000, 12_500, 15_000,
                               25_000, 50_000, 100_000,
                               250_000, 500_000, 1_000_000 ]
    let guaranteedIndices: Set<Int> = [4, 9]
    
    
    init() {
        loadQuestions()
    }
    
    private func loadQuestions() {
        if let url = Bundle.main.url(forResource: "questions", withExtension: "json") {
            print("Файл найден: \(url)")
            do {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode(QuestionWrapper.self, from: data)
                self.questions = decoded.questions
                print("Загружено вопросов: \(questions.count)")
            } catch {
                print("Ошибка декодирования: \(error)")
            }
        } else {
            print("Файл questions.json не найден в Bundle")
        }
    }

    
    func checkAnswer(_ index: Int) {
        guard currentIndex < questions.count else {return}
        stopTimer()
        
        let currentQuestion = questions[currentIndex]
        if index == currentQuestion.correct {
            score += 1
            awardPrizeForCurrentQuestion()
            updateGuaranteedIfNeeded()
            nextQuestion()
        } else {
            totalWinnings = max(totalWinnings, guaranteedWinnings)
            finishGame()
        }
    }
    
    func nextQuestion() {
        if currentIndex + 1 < questions.count {
            currentIndex += 1
            startTimer()
        } else {
            finishGame()
        }
    }
    
    private func awardPrizeForCurrentQuestion() {
        totalWinnings = prizeForQuestion(index: currentIndex)
    }
    
    private func updateGuaranteedIfNeeded() {
        if guaranteedIndices.contains(currentIndex) {
            guaranteedWinnings = totalWinnings
        }
    }
    
    func prizeForQuestion(index: Int) -> Int {
        let i = min(index, prizeLevels.count - 1)
        return prizeLevels[i]
    }
    
    
    private func finishGame() {
        stopTimer()
        showResult = true
    }
    
    func startTimer() {
        stopTimer()
        timeRemaining = 30
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.timeRemaining -= 1
                if self.timeRemaining <= 0 {
                    self.totalWinnings = max(self.totalWinnings, self.guaranteedWinnings)
                    self.finishGame()
                }
            }
    }
    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}



struct TimerBarView: View {
    @Binding var timeRemaining: Int
    let totalTime: Int
    let height: CGFloat

    private var fraction: CGFloat {
        guard totalTime > 0 else { return 0 }
        return max(CGFloat(timeRemaining) / CGFloat(totalTime), 0)
    }
    
    var body: some View {
        
        Text("\(timeRemaining)")
            .font(.system(size: height * 0.9, weight: .bold, design: .rounded))
            .foregroundColor(timeRemaining <= 15 ? (timeRemaining <= 7 ? .red1 : .yellow2)  : .white)
            .frame(minWidth: 36, alignment: .trailing)
    }
}
