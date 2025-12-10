import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameVM: GameViewModel
    @StateObject private var viewModel = QuestionModel()
    @State private var selectedAnswer: Int? = nil
    @State private var goToLevel = false
    
    @State private var showAudienceResults = false
    @State private var audiencePercentages: [Int] = []
    @State private var showPhoneResult = false
    @State private var phoneSuggestion: (index: Int, confidence: Int)? = nil
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 40) {
                // MARK: - Game Over
                if viewModel.showResult {
                    VStack { }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                goToLevel = true
                            }
                        }
                        .padding()
                }
                // MARK: - Question
                else if !viewModel.questions.isEmpty {
                    let question = viewModel.questions[viewModel.currentIndex]
                    
                    HStack(alignment: .center, spacing: 7) {
                        Image(viewModel.timeRemaining <= 15 ? (viewModel.timeRemaining <= 7 ? "timer_stop" : "timer_half") : "timer_start")
                        TimerBarView(timeRemaining: $viewModel.timeRemaining, totalTime: 30, height: 28)
                    }
                    .foregroundStyle(.white.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                            .stroke(
                                viewModel.timeRemaining <= 15
                                    ? (viewModel.timeRemaining <= 7 ? .red1.opacity(0.5) : .yellow2.opacity(0.5))
                                    : .white.opacity(0.5),
                                lineWidth: 35
                            )
                    )
                    
                    Text(question.question)
                        .foregroundColor(.white)
                        .font(Fonts.headline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 340)
                        .padding(20)
                    
                    // MARK: - Answers
                    AnswersView(viewModel: viewModel, selectedAnswer: $selectedAnswer, question: question)
                        .padding()
                    
                    // MARK: - Help Buttons
                    HelpButtonsView(
                        viewModel: viewModel,
                        showAudienceResults: $showAudienceResults,
                        audiencePercentages: $audiencePercentages,
                        showPhoneResult: $showPhoneResult,
                        phoneSuggestion: $phoneSuggestion
                    )
                }
            }
        }
        .sheet(isPresented: $showAudienceResults) {
            AudienceSheet(viewModel: viewModel, percentages: $audiencePercentages, showSheet: $showAudienceResults)
        }
        .sheet(isPresented: $showPhoneResult) {
            PhoneSheet(viewModel: viewModel, suggestion: $phoneSuggestion, showSheet: $showPhoneResult)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Сохраняем игру перед выходом с передачей viewModel
                    gameVM.saveGame(questionModel: viewModel)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("back").resizable().scaledToFit().frame(width: 25)
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
                    Image("level").resizable().scaledToFit().frame(width: 25)
                }
            }
        }
        .toolbarBackground(Color.clear, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationDestination(isPresented: $goToLevel) {
            ResultView()
        }
        .onAppear {
            if gameVM.hasPausedGame && !viewModel.questions.isEmpty {
                // Если есть сохраненная игра, восстанавливаем ее
                gameVM.resumeGame(questionModel: viewModel)
            }
            
            if !viewModel.questions.isEmpty {
                viewModel.startTimer()
            }
        }
        .onChange(of: viewModel.currentIndex) { newValue, _ in
            viewModel.removedAnswerIndices.removeAll()
            viewModel.startTimer()
        }
    }
}
#Preview {
    NavigationStack {
        GameoverView()
            .environmentObject(GameViewModel())
    }
}
