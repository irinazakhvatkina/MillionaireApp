import SwiftUI

struct GameIcon: View {
    private let name: String
    
    init(name: String) {
        self.name = name
    }
    
    var fixedSize: CGFloat {
        IconCotalog.sizes[name] ?? 32
    }
    
    var body: some View {
        Image(name)
            .resizable()
            .renderingMode(.original)
            .scaledToFit()
            .frame(width: fixedSize, height: fixedSize )
    }
}
