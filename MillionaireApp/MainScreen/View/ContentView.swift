import SwiftUI

struct HomeView: View {
    @State private var showRules = false
    @State private var goToGame = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                GradientBackground()
                
                // MARK: - Rulse
                Button(action: { showRules = true}) {
                    GameIcon(name: "help")
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                }
                
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
                        .padding(.top, -80)
                    
                    
                //  MARK: - Custom button
                    CustomButton(
                        title: "New game",
                        color: .yellowButton,
                        sizeButton: CGSize(width: 310, height: 60),
                        action: {
                            goToGame = true
                        }
                    ).padding(.top, 140)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .ignoresSafeArea()
            
            // MARK: - Sheet for Rules
            .sheet(isPresented: $showRules) {
                RulesView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .navigationDestination(isPresented: $goToGame) {
                GameView()
            }
        }
    }
}

#Preview {
    HomeView()
}
