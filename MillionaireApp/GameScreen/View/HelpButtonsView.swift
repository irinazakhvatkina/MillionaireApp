import SwiftUI

struct HelpButtonsView: View {
    @ObservedObject var viewModel: QuestionModel
    @Binding var showAudienceResults: Bool
    @Binding var audiencePercentages: [Int]
    @Binding var showPhoneResult: Bool
    @Binding var phoneSuggestion: (index: Int, confidence: Int)?

    var body: some View {
        HStack(spacing: 30) {
            // 50/50
            Button(action: {
                _ = viewModel.use5050()
            }) {
                Image("button50")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
                    .opacity(viewModel.used5050 ? 0.4 : 1.0)
            }
            .disabled(viewModel.used5050)

            // Аудитория
            Button(action: {
                audiencePercentages = viewModel.askAudience()
                showAudienceResults = true
                viewModel.stopTimer()
            }) {
                Image("buttonAudience")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
                    .opacity(viewModel.usedAudience ? 0.4 : 1.0)
            }
            .disabled(viewModel.usedAudience)

            // Звонок другу
            Button(action: {
                if let result = viewModel.phoneAFriend() {
                    phoneSuggestion = (result.suggestion, result.confidence)
                    showPhoneResult = true
                    viewModel.stopTimer()
                }
            }) {
                Image("buttonCall")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
                    .opacity(viewModel.usedPhone ? 0.4 : 1.0)
            }
            .disabled(viewModel.usedPhone)
        }
        .padding(.bottom, 30)
    }
}
