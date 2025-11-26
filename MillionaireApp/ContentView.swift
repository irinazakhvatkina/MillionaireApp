import SwiftUI

struct HomeView: View {
    @State private var showRules = false

    var body: some View {
        ZStack(alignment: .topTrailing) {

            // MARK: - Rulse
            Button(action: { showRules = true}) {
                Image("help")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.blue)
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


                // FIXME: Custom button
                Button("New Game") { }
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: 240)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.top, 150)

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
