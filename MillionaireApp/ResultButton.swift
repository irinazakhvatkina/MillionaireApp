import SwiftUI

struct MoneyButton: View {
    var number: Int
    var amount: String
    var color: ButtonColor
    var size: CGSize
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text("\(number):")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Text(amount)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(25)
            .frame(maxWidth: 311)
            .frame(height: size.height)
            .background(LinearGradient(colors: color.colors,
                                       startPoint: .top,
                                       endPoint: .bottom))
            .clipShape(CustomShape())
        }
        .overlay(
            CustomShape()
                .stroke(Color.white, lineWidth: 3)
        )
        .frame(width: size.width, height: size.height)
    }
}

