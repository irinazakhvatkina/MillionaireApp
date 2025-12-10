import SwiftUI

struct GameoverView: View {
    @EnvironmentObject var gameVM: GameViewModel
    @State private var goToGame = false
    @State private var goToHome = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            GradientBackground()
            
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 400, height: 400)
                
                Text("Game over!")
                    .font(Fonts.title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .offset(y: -80)
                
                Text("Level \(gameVM.currentLevel)")
                    .font(Fonts.small)
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .multilineTextAlignment(.center)
                    .offset(y: -40)
                
                HStack(spacing: 8) {
                    Text("$\(gameVM.totalWinnings.formatted(.number.grouping(.automatic)))")
                        .font(Fonts.headline)
                        .foregroundColor(.white)

                    Image("token")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .offset(y: -20)
                
                // MARK: - Buttons
                CustomButton(
                    title: "New game",
                    color: .yellowButton,
                    sizeButton: CGSize(width: 310, height: 60),
                    action: {
                        gameVM.startNewGame()
                        goToGame = true
                    }
                )
                .padding(.top, 140)
                
                CustomButton(
                    title: "Main screen",
                    color: .blueButton,
                    sizeButton: CGSize(width: 310, height: 60),
                    action: {
                        goToHome = true
                    }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
        // MARK: - Navigation Destinations (современный способ)
        .navigationDestination(isPresented: $goToGame) {
            GameView()
                .environmentObject(gameVM)
        }
        .navigationDestination(isPresented: $goToHome) {
            SecondView()
                .environmentObject(gameVM)
        }
    }
}

#Preview {
    NavigationStack {
        GameoverView()
            .environmentObject(GameViewModel())
    }
}
