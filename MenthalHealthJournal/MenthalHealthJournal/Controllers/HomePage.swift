import SwiftUI

struct HomePage: View {
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Image("menthalHealthLogo")
                    .resizable()
                    .scaledToFit()
                    // Size increased for an iPhone screen while maintaining aspect ratio
                    .frame(width: 320)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    // Reduced padding since the larger image takes up more space
                    .padding(.bottom, 32)

                Text("Mental Health\nJournal")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)

                Text("Track your mood, reflect on your day,\nand chat with AI about your feelings.")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40)

                Spacer()

                VStack(spacing: 12) {
                    NavigationLink(destination: SignUp()) {
                        Text("Get Started")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppTheme.accent)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }

                    NavigationLink(destination: Login()) {
                        Text("I already have an account")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppTheme.inputBg)
                            .foregroundColor(AppTheme.accent)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(AppTheme.border, lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomePage()
    }
}
