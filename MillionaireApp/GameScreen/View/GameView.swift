import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = QuestionModel()
    @State private var selectedAnswer: Int? = nil
    @State private var goToLevel = false
    @State private var finishGame = false
    
    
    @State private var showAudienceResults: Bool = false
    @State private var audiencePercentages: [Int] = []
    @State private var showPhoneResult: Bool = false
    @State private var phoneSuggestion: (index: Int, confidence: Int)? = nil
    
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
                            finishGame = true
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
                                
                                
                                if index == question.correct {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        viewModel.stopTimer()
                                        viewModel.checkAnswer(index)
                                        withAnimation(.spring(response: 1.25, dampingFraction: 0.7)) {
                                            goToLevel = true
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            withAnimation(.easeInOut(duration: 1.25)) {
                                                selectedAnswer = nil
                                            }}
                                    }
                                } else {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            finishGame = true
                                            selectedAnswer = nil
                                        }
                                    }
//                                    
                                }
                                    .disabled(selectedAnswer != nil || isRemoved)
                            }
                        
                    }
                    .padding()
                    
                    HStack(spacing: 30) {
                        Button(action: {
                            let _ = viewModel.use5050()
                            print(viewModel.removedAnswerIndices)
                        }) {
                            Image("button50")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90)
                                .opacity(viewModel.used5050 ? 0.4 : 1.0)
                        }
                        .disabled(viewModel.used5050)
                        
                        Button(action: {
                            audiencePercentages = viewModel.askAudience()
                            showAudienceResults = true
                            viewModel.stopTimer()
                        }) {
                            Image("buttonAudience")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90)
                                .opacity(viewModel.usedAudience ? 0.4 : 1.0)
                        }
                        .disabled(viewModel.usedAudience)
                        
                        Button(action: {
                            if let result = viewModel.phoneAFriend() {
                                phoneSuggestion = (result.suggestion, result.confidence)
                                showPhoneResult = true
                                viewModel.stopTimer()
                                
                            }
                        }) {
                            Image("buttonCall")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90)
                                .opacity(viewModel.usedPhone ? 0.4 : 1.0)
                        }
                        .disabled(viewModel.usedPhone)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .sheet(isPresented: $showAudienceResults) {
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
                                Text("\(audiencePercentages.indices.contains(i) ? audiencePercentages[i] : 0)%")
                                    .bold()
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal)
                        }
                    }
                    Button("Close") {
                        showAudienceResults = false
                        viewModel.startTimer()
                    }
                        .padding(.top, 12)
                        .foregroundStyle(.white)
                        .bold()
                    
                }
                .padding()
            }
        }
        
        .sheet(isPresented: $showPhoneResult) {
            ZStack {
                GradientBackground().ignoresSafeArea()
                VStack{
                    if let suggestion = phoneSuggestion,
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
                        showPhoneResult = false
                        viewModel.startTimer()}
                        .padding(.top, 12)
                        .foregroundStyle(.white)
                        .font(.title2)
                        .bold()
                    
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
                .environmentObject(viewModel)
            
        }
        
        .navigationDestination(isPresented: $finishGame) {
            GameoverView()
            
        }
        .onAppear() {
            if !viewModel.questions.isEmpty {
                viewModel.startTimer()
            }
        }
        
        .onChange(of: viewModel.currentIndex) { _ in
            viewModel.removedAnswerIndices.removeAll()
            viewModel.startTimer()
        }
    }
}

#Preview {
    NavigationStack {
        GameView()
    }
}
