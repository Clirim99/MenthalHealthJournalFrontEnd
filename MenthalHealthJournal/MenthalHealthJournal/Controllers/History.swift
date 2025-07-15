import SwiftUI

struct SidebarView: View {
    @Binding var selectedItem: String?

    let historyStories = ["Monday Entry", "Mood Reflection", "Walk in the Park", "Therapy Notes"]

    var body: some View {
        List(selection: $selectedItem) {
            Section(header: Text("Menu").foregroundColor(.white)) {
                Button("Home") {
                    selectedItem = "Home"
                }
                .foregroundColor(.black)

                Button("Journal") {
                    selectedItem = "Journal"
                }
                .foregroundColor(.black)

                Button("Settings") {
                    selectedItem = "Settings"
                }
                .foregroundColor(.black)
            }

            Section(header: Text("History").foregroundColor(.white)) {
                ForEach(historyStories, id: \.self) { story in
                    Button(story) {
                        selectedItem = story
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .scrollContentBackground(.hidden) // hides default background of List
//        .background(Color.blue)
        .background(
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .listStyle(SidebarListStyle())
        .background(DisableBackSwipe())
    }
}

#Preview {
    SidebarView(selectedItem: .constant("Home"))
}
