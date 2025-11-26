import SwiftUI

struct RulesView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack{
            HStack (spacing: -30){
                Button("Close") {
                    dismiss()
                }
                .foregroundColor(.blue)
                Spacer()
                
                Text("Rules")
                    .font(.title)
                    .bold()
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.top, 20)

            // MARK: - Scrollable Content
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("""
Objective:
Answer all 15 questions correctly to win the grand prize of 1,000,000.

How to Play:
• Each question has four possible answers — only one is correct.
• The difficulty increases with each new question.
• Once an answer is chosen, it cannot be changed.

Lifelines:
• 50/50 – removes two incorrect answers.
• Phone a Friend – gives a hint or probability.
• Ask the Audience – shows audience vote percentages.

End of Game:
• Win – answer all 15 correctly.
• Lose – wrong answer before a guaranteed level.
• Walk Away – stop anytime and take your winnings.
""")
                    .font(.body)
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
            }

            Spacer(minLength: 0)
        }
        .ignoresSafeArea(edges: .top)
    }
}
