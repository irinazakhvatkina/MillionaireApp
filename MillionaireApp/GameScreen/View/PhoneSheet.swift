import SwiftUI

struct PhoneSheet: View {
    @ObservedObject var viewModel: QuestionModel
    @Binding var suggestion: (index: Int, confidence: Int)?
    @Binding var showSheet: Bool

    var body: some View {
        ZStack {
            GradientBackground().ignoresSafeArea()
            VStack {
                if let suggestion = suggestion,
                   viewModel.questions.indices.contains(viewModel.currentIndex) {
                    let q = viewModel.questions[viewModel.currentIndex]
                    let answerText = q.answers[suggestion.index]
                    VStack {
                        Text("Phone a Friend")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .bold()
                        Image("call")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90)
                            .padding(.bottom, 40)
                        Text("Friend suggests: \"\(answerText)\" with \(suggestion.confidence)% confidence")
                            .foregroundStyle(.white)
                            .bold()
                            .font(.title)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Button("OK") {
                    showSheet = false
                    viewModel.startTimer()
                }
                .padding(.top, 12)
                .foregroundStyle(.white)
                .font(.title2)
                .bold()
            }
        }
    }
}
