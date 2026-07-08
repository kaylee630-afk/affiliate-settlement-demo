import SwiftUI

struct ContentView: View {
    @Environment(PayStore.self) private var store
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(switchToSend: { selectedTab = 1 })
                .tabItem { Label("Home", systemImage: "house.fill") }.tag(0)

            SendView()
                .tabItem { Label("Send", systemImage: "paperplane.fill") }.tag(1)

            ActivityView()
                .tabItem { Label("Activity", systemImage: "list.bullet.rectangle.fill") }.tag(2)

            ProfileView()
                .tabItem { Label("Account", systemImage: "person.circle.fill") }.tag(3)
        }
    }
}
