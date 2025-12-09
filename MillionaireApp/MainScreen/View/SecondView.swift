import SwiftUI

struct SecondView: View {
    
    @State private var goToGame = false
    @State private var showRules = false
    
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
                    
                    Text("Who Wants\n to Be a Millionaire?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, -50)
                    
                    Text("Level 8")
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
                        Text("$15,000")
                            .font(Fonts.headline)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 8)
                    
                // MARK: - CustomButton
                    CustomButton(
                        title: "New game",
                        color: .blueButton,
                        sizeButton: CGSize(width: 310, height: 60),
                        action: { goToGame = true }
                    )
                    .padding(.top, 100)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Button(action: { showRules = true }) {
                    GameIcon(name: "help")
                }
                .padding(.top, 50)
                .padding(.trailing, 20)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea()
            .navigationDestination(isPresented: $goToGame) {
                GameView()
            }
            .sheet(isPresented: $showRules) {
                RulesView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    SecondView()
}
