import SwiftUI

struct FeelingsDscController: View {
    @State private var feelingsText: String = ""
    @State private var sliderValue: Double = 5
    @State private var emojisImageName = "expresionLess"
    @State private var isSending = false

    @State private var showToast = false
    @State private var toastMessage = ""

    @FocusState private var isFocused: Bool

    private var sentimentScore: Int { max(1, min(10, Int(sliderValue.rounded()))) }

    private var moodLabel: String {
        switch sentimentScore {
        case 1...2: return "Very Sad"
        case 3...4: return "Sad"
        case 5...6: return "Neutral"
        case 7...8: return "Happy"
        case 9...10: return "Very Happy"
        default: return ""
        }
    }

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text("How are you feeling?")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.top, 24)

                    Image(emojisImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 30))

                    VStack(spacing: 8) {
                        Text(moodLabel)
                            .font(.headline)
                            .foregroundColor(AppTheme.accent)

                        Text("\(sentimentScore) / 10")
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)

                        Slider(value: $sliderValue, in: 1...10, step: 1)
                            .accentColor(AppTheme.accent)
                            .padding(.horizontal)
                            .onChange(of: sliderValue) { newValue in
                                updateEmoji(for: Int(newValue.rounded()))
                            }
                    }
                    .padding()
                    .background(AppTheme.cardBg)
                    .cornerRadius(16)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("What's on your mind?")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(AppTheme.textSecondary)

                        TextEditor(text: $feelingsText)
                            .frame(minHeight: 140)
                            .padding(12)
                            .scrollContentBackground(.hidden)
                            .background(AppTheme.inputBg)
                            .foregroundColor(AppTheme.textPrimary)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppTheme.border, lineWidth: 1)
                            )
                            .focused($isFocused)
                            .overlay(alignment: .topLeading, content: {
                                if feelingsText.isEmpty && !isFocused {
                                    Text("Describe your day...")
                                        .foregroundColor(AppTheme.textMuted)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 20)
                                        .allowsHitTesting(false)
                                }
                            })
                    }
                    .padding(.horizontal)

                    Button {
                        saveEntry()
                    } label: {
                        HStack {
                            if isSending {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "arrow.up.circle.fill")
                                Text("Save Entry")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(canSend ? AppTheme.accent : AppTheme.accent.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .disabled(!canSend)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .onTapGesture { isFocused = false }
        }
        .showToast(text: toastMessage, isShowing: $showToast)
    }

    private var canSend: Bool {
        !isSending && !feelingsText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func saveEntry() {
        let trimmed = feelingsText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard trimmed.count <= 5000 else {
            showToastMessage("Entry is too long (max 5000 characters)")
            return
        }

        let userId = UserSession.shared.userId
        guard !userId.isEmpty else {
            showToastMessage("Please log in again")
            return
        }

        isSending = true
        createEntry(content: trimmed, sentimentScore: sentimentScore, userId: userId) { result in
            DispatchQueue.main.async {
                isSending = false
                switch result {
                case .success:
                    feelingsText = ""
                    sliderValue = 5
                    updateEmoji(for: 5)
                    showToastMessage("Entry saved!")
                case .failure(let error):
                    showToastMessage(error.localizedDescription)
                }
            }
        }
    }

    private func showToastMessage(_ text: String) {
        toastMessage = text
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showToast = false
        }
    }

    private func updateEmoji(for score: Int) {
        switch score {
        case 1...2: emojisImageName = "verysad"
        case 3...4: emojisImageName = "sad"
        case 5...6: emojisImageName = "expresionLess"
        case 7...8: emojisImageName = "happy"
        case 9...10: emojisImageName = "veryhappy"
        default: emojisImageName = "expresionLess"
        }
    }
}

#Preview {
    FeelingsDscController()
}
