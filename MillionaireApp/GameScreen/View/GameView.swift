import SwiftUI

struct GameView: View {

    @StateObject private var viewModel = QuestionModel()
    @State private var selectedAnswer: Int? = nil
    @State private var goToLevel = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 40) {
                Spacer().frame(height: 70)
                
                if viewModel.showResult {
                    // MARK: - Game Over Screen
                    VStack(spacing: 20) {
                        Text("Game Over!")
                            .font(.largeTitle)
                        Text("Your score: \(viewModel.score) / \(viewModel.questions.count)")
                            .padding()
                        Button("Back to Levels") {
                            goToLevel = true
                        }
//                        .buttonStyle(CustomButtonStyle(color: .blueButton))
                    }
                    .padding()
                } else if !viewModel.questions.isEmpty {
                    // MARK: - Current Question
                    let question = viewModel.questions[viewModel.currentIndex]
                    
                    Text(question.question)
                        .foregroundStyle(.white)
                        .bold()
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    VStack(spacing: 20) {
                        ForEach(0..<question.answers.count, id: \.self) { index in
                            CustomButton(title: question.answers[index],
                                         color: selectedAnswer == index ? (index == question.correct ? .greenButton : .redButton) : .blueButton,
                                         sizeButton: CGSize(width: 340, height: 40)) {
                                guard selectedAnswer == nil else { return }
                                selectedAnswer = index
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    viewModel.checkAnswer(index)
                                    selectedAnswer = nil
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // MARK: - Lifelines
                HStack(spacing: 30) {
                    Button(action: { print("50:50") }) {
                        Image("button50")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90)
                    }
                    Button(action: { print("Audience") }) {
                        Image("buttonAudience")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90)
                    }
                    Button(action: { print("Call") }) {
                        Image("buttonCall")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image("back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 20)
                }
            }
            
            ToolbarItem(placement: .principal) {
                VStack(spacing: 5) {
                    Text("QUESTION #\(viewModel.currentIndex + 1)")
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .font(Fonts.small)
                    Text("$500")
                        .foregroundColor(.white)
                        .font(Fonts.body)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { goToLevel = true }) {
                    Image("level")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                }
            }
        }
        .toolbarBackground(Color.clear, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationDestination(isPresented: $goToLevel) {
            ResultView()
        }
    }
}

#Preview {
    NavigationStack {
        GameView()
    }
}
