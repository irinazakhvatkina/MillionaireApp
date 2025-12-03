import SwiftUI

struct GradientBackground: View {
    var body: some View {
        ZStack {
            // Основной градиент (сверху светлый, снизу темный)
            LinearGradient(
                gradient: Gradient(colors: [Color.primaryBlue.opacity(0.9), Color.darkBackground.opacity(1)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Размытые голубые круги
            Circle()
                .fill(Color.accentBlue.opacity(0.8))
                .frame(width: 320, height: 320)
                .blur(radius: 60)
                .offset(x: -150, y: -150)
            
            Circle()
                .fill(Color.accentBlue.opacity(0.7))
                .frame(width: 180, height: 180)
                .blur(radius: 50)
                .offset(x: 150, y: 180)
            
        }
    }
}
