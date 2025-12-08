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
                // MARK: - Game Over
                if viewModel.showResult {
                    VStack {
                    }
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                            goToLevel = true
                        }
                    }
                    .padding()
                }
                
                
                // MARK: - Question
                else if !viewModel.questions.isEmpty {
                    let question = viewModel.questions[viewModel.currentIndex]
                    
                    HStack (alignment: .center, spacing: 7){
                        Image(viewModel.timeRemaining <= 15 ? (viewModel.timeRemaining <= 7 ? "timer_stop" : "timer_half")  : "timer_start")
                        TimerBarView(timeRemaining: $viewModel.timeRemaining, totalTime: 30, height: CGFloat(28))
                    }
                    .foregroundStyle(.white.opacity(0.5))
                    .overlay(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)).stroke(viewModel.timeRemaining <= 15 ? (viewModel.timeRemaining <= 7 ? .red1.opacity(0.5) : .yellow2.opacity(0.5))  : .white.opacity(0.5), lineWidth: 35))
                    
                    Text(question.question)
                        .foregroundColor(.white)
                        .font(Fonts.headline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 340)
                        .padding(20)
                    
                    // MARK: - Answers
                    VStack(spacing: 25) {
                        ForEach(0..<question.answers.count, id: \.self) { index in
                            CustomButton(
                                title: question.answers[index],
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
                        }
                    }
                    .padding()
                    
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
        }
        
        // MARK: - Toolbar
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image("back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                }
            }
            
            ToolbarItem(placement: .principal) {
                VStack(spacing: 5) {
                    Text("QUESTION #\(viewModel.currentIndex + 1)")
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .font(Fonts.small)
                    
                    Text("$\(viewModel.totalWinnings)")
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
        .onAppear() {
            if !viewModel.questions.isEmpty {
                viewModel.startTimer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        GameView()
    }
}
