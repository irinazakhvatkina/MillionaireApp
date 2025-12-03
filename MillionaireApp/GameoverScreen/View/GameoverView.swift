import SwiftUI

struct GameoverView: View {
    
    @State private var goToGame = false
    @State private var goToHome = false

var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                GradientBackground()
                
                // MARK: - Center Content
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 400, height: 400)
                    
                    Text("Game over!")
                        .font(Fonts.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, -80)
                    
                    Text("Level 8")
                        .font(Fonts.small)
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .padding(.top, -40)
                    
                    HStack(spacing: 8) {
                        Text("$15,000")
                            .font(Fonts.headline)
                            .foregroundColor(.white)

                        Image("token")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    }
                    .padding(.top, -20)
                    
                    //  MARK: - Custom button
                    CustomButton(
                        title: "New game",
                        color: .yellowButton,
                        sizeButton: CGSize(width: 310, height: 60),
                        action: {  goToGame = true }
                    ).padding(.top, 140)
                    
                    CustomButton(
                        title: "Main screen",
                        color: .blueButton,
                        sizeButton: CGSize(width: 310, height: 60),
                        action: { goToHome = true }
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea()
            .navigationDestination(isPresented: $goToGame) {
                GameView()
            }
            .navigationDestination(isPresented: $goToHome) {
                HomeView()
            }
        }
    }
}

#Preview {
    GameoverView()
}
