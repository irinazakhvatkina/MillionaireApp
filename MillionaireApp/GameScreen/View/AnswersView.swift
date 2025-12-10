import SwiftUI

struct AnswersView: View {
    @ObservedObject var viewModel: QuestionModel
    @Binding var selectedAnswer: Int?
    
    var question: Question
    
    var body: some View {
        VStack(spacing: 25) {
            ForEach(0..<question.answers.count, id: \.self) { index in
                let isRemoved = viewModel.removedAnswerIndices.contains(index)
                
                CustomButton(
                    title: isRemoved ? "" : question.answers[index],
                    color: selectedAnswer == index
                        ? (index == question.correct ? .greenButton : .redButton)
                        : .blueButton,
                    sizeButton: CGSize(width: 340, height: 40)
                ) {
                    guard selectedAnswer == nil else { return }
                    selectedAnswer = index
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        viewModel.checkAnswer(index)
                        selectedAnswer = nil
                    }
                }
                .disabled(selectedAnswer != nil || isRemoved)
            }
        }
    }
}
