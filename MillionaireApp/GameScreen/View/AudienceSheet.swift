import SwiftUI

struct AudienceSheet: View {
    @ObservedObject var viewModel: QuestionModel
    @Binding var percentages: [Int]
    @Binding var showSheet: Bool

    var body: some View {
        ZStack {
            GradientBackground().ignoresSafeArea()
            VStack {
                Text("Audience Poll")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .bold()
                
                if viewModel.questions.indices.contains(viewModel.currentIndex) {
                    let q = viewModel.questions[viewModel.currentIndex]
                    ForEach(0..<q.answers.count, id: \.self) { i in
                        HStack {
                            Text(q.answers[i])
                                .foregroundStyle(.white)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(percentages.indices.contains(i) ? percentages[i] : 0)%")
                                .bold()
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Button("Close") {
                    showSheet = false
                    viewModel.startTimer()
                }
                .padding(.top, 12)
                .foregroundStyle(.white)
                .bold()
            }
            .padding()
        }
    }
}
