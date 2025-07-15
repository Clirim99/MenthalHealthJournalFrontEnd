import SwiftUI

struct MainControllerView: View {
    @State private var showSidebar = false
    @State private var selectedItem: String? = "Home"

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                if showSidebar {
                    SidebarView(selectedItem: $selectedItem)
                        .frame(width: geometry.size.width / 2.5)
                        .transition(.move(edge: .leading))
                        .background(DisableBackSwipe())

                }
                
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                showSidebar.toggle()
                            }
                        }) {
                            Image(systemName: "sidebar.leading")
                                .font(.title2)
                                .foregroundColor(.white) // 👈 Set button color to white
                        }
                        .padding()
                        
                        Spacer()
                    }
                    Divider()
                    
                    FeelingsDscController()

                    Spacer()
                }
                .frame(width: showSidebar ? geometry.size.width * 2/3 : geometry.size.width)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
             //   .ignoresSafeArea()
                
            }
            .animation(.easeInOut, value: showSidebar)
            .background(DisableBackSwipe())
        }
    }
    
}

struct MainControllerView_Previews: PreviewProvider {
    static var previews: some View {
        MainControllerView()
    }
}
