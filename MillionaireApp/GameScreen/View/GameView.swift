import SwiftUI

struct GameView: View {
    
    @State private var isPressed1 = false
    @State private var isPressed2 = false
    @State private var isPressed3 = false
    @State private var isPressed4 = false
    
    var body: some View {
        ZStack {
            Color(.blue2).ignoresSafeArea()
            
            
            VStack{
                
                HStack (spacing:100){
                    Button(action: {
                        print("back")
                    }) {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .frame(width: 25, height: 20)
                            .bold()
                    }
                    
                    VStack (spacing: 10) {
                        Text("Question №1")
                            .foregroundStyle(.white)
                            .opacity(0.5)
                        Text("$500")
                            .foregroundStyle(.white)
                    }
                    
                    Button(action: {
                        print("List of Answers")
                    }) {
                        Image(.menuButton)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                    }
                } .padding(.bottom, 70)
                
                VStack(spacing: 20) {
                    
                    Text("What is the birthstone of the month of April?")
                        .font(.title)
                        .frame(maxWidth: 340, alignment: .center)
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .bold()
                        .padding(.bottom, 50)
                    CustomButton(title: "A:   Diamond", color: isPressed1 ? .greenButton : .blueButton, sizeButton: CGSize(width: 311, height: 30)) {
                        withAnimation(.easeInOut) {
                            isPressed1.toggle()
                        }
                    }
                    CustomButton(title: "B:   Sapphire", color: isPressed2 ? .redButton : .blueButton, sizeButton: CGSize(width: 311, height: 30)) {
                        withAnimation(.easeInOut) {
                            isPressed2.toggle()
                        }
                    }
                    CustomButton(title: "C:   Garnet", color: isPressed3 ? .redButton : .blueButton, sizeButton: CGSize(width: 311, height: 30)) {
                        withAnimation(.easeInOut) {
                            isPressed3.toggle()
                        }
                    }
                    CustomButton(title: "D:   Emerald", color: isPressed4 ? .redButton : .blueButton, sizeButton: CGSize(width: 311, height: 30)) {
                        withAnimation(.easeInOut) {
                            isPressed4.toggle()
                        }
                    }
                }
                .padding(40)
                
                HStack (spacing: 30){
                    Button(action: {
                     print("50:50")
                    }) {
                        Image(.button50)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90)
                    }
                    Button(action: {
                     print("Audience")
                    }) {
                        Image(.buttonAudience)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90)
                    }
                    Button(action: {
                     print("call")
                    }) {
                        Image(.buttonCall)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90)
                    }
                }
            }
            
        }
    }
}

#Preview {
    GameView()
}
