import SwiftUI

struct SecondView: View {
    @EnvironmentObject var gameVM: GameViewModel
    @State private var goToGame = false
    @State private var showRules = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            GradientBackground()
            
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 400, height: 400)
                
                Text("Who Wants\n to Be a Millionaire?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, -50)
                
                Text("Level \(gameVM.currentLevel)")
                    .font(Fonts.small)
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
                
                HStack(spacing: 8) {
                    Image("token")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    Text("$\(gameVM.totalWinnings.formatted(.number.grouping(.automatic)))")
                        .font(Fonts.headline)
                        .foregroundColor(.white)
                }
                .padding(.top, 8)
                
                CustomButton(
                    title: "New game",
                    color: .blueButton,
                    sizeButton: CGSize(width: 310, height: 60),
                    action: {
                        gameVM.startNewGame()
                        goToGame = true
                    }
                )
                .padding(.top, 100)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: { showRules = true }) {
                GameIcon(name: "help")
            }
            .padding(.top, 50)
            .padding(.trailing, 20)
            
            // MARK: - NavigationLink для игры
            NavigationLink(
                destination: GameView()
                    .environmentObject(gameVM),
                isActive: $goToGame
            ) {
                EmptyView()
            }
            .hidden()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
        .sheet(isPresented: $showRules) {
            RulesView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NavigationStack {
        SecondView()
            .environmentObject(GameViewModel())
    }
}
