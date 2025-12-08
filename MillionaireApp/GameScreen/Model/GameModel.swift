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
