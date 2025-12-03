import SwiftUI

struct ResultView: View {

    let rows: [(Int, String, ButtonColor)] = (1...15).reversed().map { i in
        let prize = "$\(i * 1000)"
        let colors: [ButtonColor] = [.blueButton, .yellowButton, .greenButton, .redButton]
        return (i, prize, colors[i % colors.count])
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
                    MoneyButton(
                        number: row.0,
                        amount: row.1,
                        color: row.2,
                        size: CGSize(width: 315, height: 36)
                    ) {
                        print("Tapped \(row.0)")
                    }
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
                        GameIcon(name: "withdrawal")
                    }
                    .padding(.leading, 20)
                    Spacer()
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
    NavigationStack {
        ResultView()
    }
}
