import SwiftUI

struct ResultView: View {

    let rows: [(Int, String, ButtonColor)] = (1...15).reversed().map { i in
        let prize = "$\(i * 1000)"
        let colors: [ButtonColor] = [.blueButton, .yellowButton, .greenButton, .redButton]
        return (i, prize, colors[i % colors.count])
    }

    var body: some View {
        ZStack {
            
            GradientBackground()

//            table
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
            
//            logo
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .offset(y: -40)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ResultView()
}
