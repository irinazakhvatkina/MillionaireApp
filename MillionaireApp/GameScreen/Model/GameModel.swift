import SwiftUI
internal import Combine

struct Question: Codable, Identifiable {
    var id = UUID()
    var question: String
    var answers: [String]
    let correct: Int
    let difficulty: String
}

struct QuestionWrapper: Codable {
    let questions: [Question]
}


class QuestionModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentIndex = 0
    @Published var score = 0
    @Published var showResult = false
    
    init() {
        loadQuestions()
    }
    
    private func loadQuestions() {
        if let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode(QuestionWrapper.self, from: data) {
            self.questions = decoded.questions
        }
    }
    
    func checkAnswer(_ index: Int) {
        let currentQuestion = questions[currentIndex]
        if index == currentQuestion.correct {
            score += 1
        }
        nextQuestion()
    }
    
    func nextQuestion() {
        if currentIndex + 1 < questions.count {
            currentIndex += 1
        } else {
            showResult = true
        }
    }
}



