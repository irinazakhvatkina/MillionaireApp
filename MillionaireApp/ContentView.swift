import SwiftUI

struct HomeView: View {
    
    var body: some View {
        ZStack(alignment: .topTrailing) {

            // MARK: - Rulse
            Button(action: { print("Rules") }) {
                Image("help")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.blue)
                    .padding()
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
    }
}

#Preview {
    HomeView()
}
