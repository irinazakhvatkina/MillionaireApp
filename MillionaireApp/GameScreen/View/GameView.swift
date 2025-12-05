import SwiftUI

struct GameView: View {

    @State private var viewModel = QuestionModel()
    @State private var selectedAnswer: Int? = nil
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack{
                
                HStack (spacing:100){
                    Button(action: {
                        print("back")
                    }) {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .frame(width: 25, height: 20)
                            .bold()
                    }
                    
                    VStack (spacing: 10) {
                        Text("Question №1")
                            .foregroundStyle(.white)
                            .opacity(0.5)
                        Text("$500")
                            .foregroundStyle(.white)
                    }
                    
                    Button(action: {
                        print("List of Answers")
                    }) {
                        Image(.menuButton)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                    }
                } .padding(.bottom, 70)
                
                VStack(spacing: 40) {
                    if viewModel.showResult {
                        Text("Game Over!")
                            .font(.largeTitle)
                        Text("Your score: \(viewModel.score) / \(viewModel.questions.count)")
                            .padding()
                    } else {
                        if !viewModel.questions.isEmpty {
                            
                            let question = viewModel.questions[viewModel.currentIndex]
                            
                            Text(question.question)
                                .foregroundStyle(.white)
                                .bold()
                                .font(.headline)
                                .padding(40)
                            ForEach(0..<question.answers.count, id: \.self) { index in
                                CustomButton(title: question.answers[index], color: selectedAnswer == index ? (index == question.correct ? .greenButton : .redButton) : .blueButton, sizeButton: CGSize(width: 340, height: 40), action: {
                                    selectedAnswer = index
                                })
                               }
                        }
                    }
                }
                .padding(40)
                
                HStack (spacing: 30){
                    Button(action: {
                        print("50:50")
                    }) {
                        Image(.button50)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90)
                    }
                    Button(action: {
                        print("Audience")
                    }) {
                        Image(.buttonAudience)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90)
                    }
                    Button(action: {
                        print("call")
                    }) {
                        Image(.buttonCall)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90)
                    }
                }
                
            }
        }
        
    }
}

#Preview {
    GameView()
}
