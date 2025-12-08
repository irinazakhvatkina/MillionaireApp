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
