import SwiftUI

struct ResultView: View {
    
    @EnvironmentObject var viewModel: QuestionModel
    @EnvironmentObject var gameVM: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var highlightedRow: Int? = nil
    @State private var animatePulse: Bool = false
    @State private var goNext = false
    
    // MARK: - Prize Rows
    // Уровни 1...15 (15 — $1,000,000)
    let prizeAmounts = [
        "500", "1.000", "2.000", "3.000", "5.000",
        "7.500", "10.000", "12.500", "15.000", "25.000",
        "50.000", "100.000", "250.000", "500.000", "1.000.000"
    ]
    
    var rows: [(Int, String, ButtonColor)] {
        (1...15).reversed().map { level in
            let index = level - 1
            let prize = prizeAmounts[index]
            
            let color: ButtonColor =
                (level == 5 || level == 10 || level == 15) ? .lightBlueButton : .blueButton
            
            return (level, prize, color)
        }
    }
    
    var onWithdraw: ((String) -> Void)?
    
    var currentPrize: String {
        rows.first?.1 ?? "$0"
    }
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            // MARK: - Table of Levels
            VStack(spacing: 0) {
                ForEach(rows, id: \.0) { row in
                    let isHighlighted =
                        (viewModel.lastCompletedLevel == row.0) || (highlightedRow == row.0)
                    
                    MoneyButton(
                        number: row.0,
                        amount: row.1,
                        color: isHighlighted ? .greenButton : row.2,
                        size: CGSize(width: 315, height: 36)
                    ) {}
                    .scaleEffect(isHighlighted && animatePulse ? 1.06 : 1.0)
                    .shadow(
                        color: isHighlighted ? Color.green.opacity(0.25) : .clear,
                        radius: isHighlighted ? 8 : 0,
                        x: 0,
                        y: 4
                    )
                    .padding(.vertical, 2)
                    .animation(.easeInOut(duration: 0.35), value: animatePulse)
                }
            }
            
            // MARK: Logo
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .offset(y: -40)
                Spacer()
            }
            
            // MARK: Withdraw Buttons
            VStack {
                HStack {
                    Button { withdrawMoney() } label: {
                        GameIcon(name: "back")
                    }
                    .padding(20)
                    
                    Spacer()
                    
                    Button { withdrawMoney() } label: {
                        GameIcon(name: "withdrawal")
                    }
                    .padding(20)
                }
                .padding(.top, 8)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        
        // MARK: Animation & Auto-dismissing
        .onAppear {
            
            // Если игрок прошёл уровень
            if let level = viewModel.lastCompletedLevel {
                highlightedRow = level
                
                // легкая задержка для красивой анимации
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    animatePulse = true
                }
                // завершение анимации и возврат к GameView
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    animatePulse = false
                    viewModel.advanceAfterResult()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            // Если ничего не выделено — просто вернуть назад
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            // через 5 секунд — Game Over переход
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                goNext = true
            }
        }
        
        // MARK: Game Over Navigation
        .navigationDestination(isPresented: $goNext) {
            GameoverView()
                .environmentObject(gameVM)
        }
    }
    
    // MARK: Withdraw Logic
    private func withdrawMoney() {
        print("Player withdrew: \(currentPrize)")
        onWithdraw?(currentPrize)
    }
}

#Preview {
    NavigationStack {
        ResultView()
            .environmentObject(QuestionModel())
            .environmentObject(GameViewModel())
    }
}
