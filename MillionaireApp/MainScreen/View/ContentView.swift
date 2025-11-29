import SwiftUI

struct HomeView: View {
    @State private var showRules = false

    var body: some View {
        ZStack(alignment: .topTrailing) {

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
                        print("New game")
                    }
                ).padding(.top, 140)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.gray)
        .ignoresSafeArea()
        
        // MARK: - Sheet for Rules
        .sheet(isPresented: $showRules) {
            RulesView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    HomeView()
}
