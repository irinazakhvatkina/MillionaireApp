import SwiftUI

struct GameView: View {

    @State private var viewModel = QuestionModel()
    @State private var selectedAnswer: Int? = nil
    @State private var goToLevel = false
    
    @State private var isPressed1 = false
    @State private var isPressed2 = false
    @State private var isPressed3 = false
    @State private var isPressed4 = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 40) {
                // MARK: - Question
                Spacer().frame(height: 70)
                Text("What is the birthstone of the month of April?")
                    .font(Fonts.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 340)
                
                // MARK: - Answers
                CustomButton(title: "A: Diamond", color: isPressed1 ? .greenButton : .blueButton, sizeButton: CGSize(width: 311, height: 30)) {
                    withAnimation(.easeInOut) { isPressed1.toggle() }
                }
                CustomButton(title: "B: Sapphire", color: isPressed2 ? .redButton : .blueButton, sizeButton: CGSize(width: 311, height: 30)) {
                    withAnimation(.easeInOut) { isPressed2.toggle() }
                }
                CustomButton(title: "C: Garnet", color: isPressed3 ? .redButton : .blueButton, sizeButton: CGSize(width: 311, height: 30)) {
                    withAnimation(.easeInOut) { isPressed3.toggle() }
                }
                CustomButton(title: "D: Emerald", color: isPressed4 ? .redButton : .blueButton, sizeButton: CGSize(width: 311, height: 30)) {
                    withAnimation(.easeInOut) { isPressed4.toggle() }
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
                
                // MARK: - Questions from ViewModel
                if viewModel.showResult {
                    VStack {
                        Text("Game Over!")
                            .font(.largeTitle)
                        Text("Your score: \(viewModel.score) / \(viewModel.questions.count)")
                            .padding()
                    }
                } else if !viewModel.questions.isEmpty {
                    let question = viewModel.questions[viewModel.currentIndex]
                    VStack(spacing: 20) {
                        Text(question.question)
                            .foregroundStyle(.white)
                            .bold()
                            .font(.headline)
                            .padding(40)
                        ForEach(0..<question.answers.count, id: \.self) { index in
                            CustomButton(title: question.answers[index],
                                         color: selectedAnswer == index ? (index == question.correct ? .greenButton : .redButton) : .blueButton,
                                         sizeButton: CGSize(width: 340, height: 40)) {
                                selectedAnswer = index
                            }
                        }
                    }
                    .padding(40)
                }
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
                    Text("QUESTION #1")
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
