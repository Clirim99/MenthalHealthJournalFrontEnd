import SwiftUI

struct AppTheme {
    static let bg = Color(red: 0.07, green: 0.07, blue: 0.14)
    static let surface = Color(red: 0.11, green: 0.11, blue: 0.20)
    static let cardBg = Color(red: 0.15, green: 0.15, blue: 0.25)
    static let accent = Color(red: 0.35, green: 0.75, blue: 0.72)
    static let accentSoft = Color(red: 0.35, green: 0.75, blue: 0.72).opacity(0.15)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    static let textMuted = Color.white.opacity(0.35)
    static let destructive = Color(red: 0.95, green: 0.35, blue: 0.35)
    static let userBubble = Color(red: 0.35, green: 0.75, blue: 0.72)
    static let aiBubble = Color(red: 0.18, green: 0.18, blue: 0.28)
    static let inputBg = Color.white.opacity(0.08)
    static let border = Color.white.opacity(0.12)

    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.07, green: 0.07, blue: 0.14),
            Color(red: 0.10, green: 0.08, blue: 0.18)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
