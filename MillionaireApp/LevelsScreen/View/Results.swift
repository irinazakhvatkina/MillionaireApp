import SwiftUI

struct ResultView: View {
    
    @EnvironmentObject var viewModel: QuestionModel
    @Environment(\.presentationMode) var presentationMode
    @State private var highlightedRow: Int? = nil
    @State private var animatePulse: Bool = false
    
    let rows: [(Int, String, ButtonColor)] = (1...15).reversed().map { i in
        let prize = [ "1.000.000" ,"500", "1.000", "2.000", "3.000", "5.000",
                      "7.500", "10.000", "12.500", "15.000","25.000", "50.000",
                      "100.000","250.000", "500.000"]
        let colors: [ButtonColor] = [.lightBlueButton, .blueButton, .blueButton, .blueButton, .blueButton]
        return (i, prize[i % prize.count], colors[i % colors.count])
    }
    
    var onWithdraw: ((String) -> Void)?
    
    @State private var goNext = false
    
    var currentPrize: String {
        rows.first?.1 ?? "$0"
    }
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            // MARK: - Table of levels
            VStack(spacing: 0) {
                ForEach(rows, id: \.0) { row in
                    let isHighlighted = (viewModel.lastCompletedLevel == row.0) || (highlightedRow == row.0)
                    MoneyButton(
                        number: row.0,
                        amount: row.1,
                        color: isHighlighted ? .greenButton : row.2,
                        size: CGSize(width: 315, height: 36)
                    ) {
                        print("Tapped \(row.0)")
                    }
                    .scaleEffect(isHighlighted && animatePulse ? 1.06 : 1.0)
                    .shadow(color: isHighlighted ? Color.green.opacity(0.25) : Color.clear, radius: isHighlighted ? 8 : 0, x: 0, y: 4)
                    .padding(.vertical, 2)
                    .animation(.easeInOut(duration: 0.35), value: animatePulse)
                }
                
                
            }
            
            // MARK: - Logo
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .offset(y: -40)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // MARK: - Withdraw Button
            VStack {
                HStack {
                    Button {
                        withdrawMoney()
                    } label: {
                        GameIcon(name: "back")
                    }
                    .padding( 20)
                    
                    Spacer()
                    Button {
                        withdrawMoney()
                    } label: {
                        GameIcon(name: "withdrawal")
                    }
                    .padding( 20)
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                goNext = true
                
            }
            if let level = viewModel.lastCompletedLevel {
                highlightedRow = level
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    animatePulse = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    animatePulse = false
                    
                    viewModel.advanceAfterResult()
                    
                    presentationMode.wrappedValue.dismiss()
                }
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationDestination(isPresented: $goNext) {
            GameoverView()
        }
    }
    
    // MARK: - Withdraw Logic
    private func withdrawMoney() {
        print("Player withdrew: \(currentPrize)")
        onWithdraw?(currentPrize)
    }
}

#Preview {
//    NavigationStack {
//        ResultView()
//    }
    NavigationStack {
            ResultView()
                .environmentObject(QuestionModel()) 
        }
}
