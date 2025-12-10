import SwiftUI

struct TimeBarView: View {
    @Binding var timeRemaining: Int
    let totalTime: Int
    let height: CGFloat
    
    private var textColor: Color {
        if timeRemaining <= 7 { return .red1 }
        if timeRemaining <= 15 { return .yellow2 }
        return .white
    }
    
    var body: some View {
        Text("\(timeRemaining)")
            .font(.system(size: height * 0.9, weight: .bold))
            .foregroundColor(textColor)
    }
}
