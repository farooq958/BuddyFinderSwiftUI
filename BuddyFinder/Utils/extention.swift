import SwiftUICore


import SwiftUI

extension Color {
    static let appPrimary = Color("PrimaryColor")
    static let appBackground = Color(uiColor: .systemGroupedBackground)
    static let cardBackground = Color(uiColor: .secondarySystemGroupedBackground)
}

struct AppTheme {
    static let cornerRadius: CGFloat = 16
    static let shadowRadius: CGFloat = 4
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.cardBackground)
            .cornerRadius(AppTheme.cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: AppTheme.shadowRadius, x: 0, y: 2)
    }
}

// Helper to make it easy to use
extension View {
    func asCard() -> some View {
        self.modifier(CardStyle())
    }
}
