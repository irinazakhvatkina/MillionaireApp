import SwiftUI

struct CustomButton: View {
    var title: String
    var color: ButtonColor
    var sizeButton: CGSize
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(colors: color.colors, startPoint: .top, endPoint: .bottom))
                .foregroundStyle(.white)
                .clipShape(CustomShape())
        } .overlay(CustomShape.init().stroke(Color.white, lineWidth: 3))
          .frame(minWidth: sizeButton.width,maxWidth: sizeButton.width, minHeight: sizeButton.height, maxHeight: sizeButton.height)
            .padding()
    }
}

struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: 0, y: rect.height / 2))
    path.addLine(to: CGPoint(x: rect.width * 0.08, y: 0))
    path.addLine(to: CGPoint(x: rect.width * 0.92, y: 0))
    path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
    path.addLine(to: CGPoint(x: rect.width * 0.92, y: rect.height))
    path.addLine(to: CGPoint(x: rect.width * 0.08, y: rect.height))
    path.closeSubpath()
    return path }
}


