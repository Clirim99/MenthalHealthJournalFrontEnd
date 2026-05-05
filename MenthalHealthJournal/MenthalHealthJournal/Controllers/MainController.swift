import SwiftUI

struct MainControllerView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            FeelingsDscController()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Journal")
                }
                .tag(0)

            HistoryView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
                .tag(1)

            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right")
                    Text("Chat")
                }
                .tag(2)
        }
        .accentColor(AppTheme.accent)
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor(AppTheme.surface)
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            UITabBar.appearance().unselectedItemTintColor = UIColor.white.withAlphaComponent(0.4)
        }
    }
}

#Preview {
    MainControllerView()
}
