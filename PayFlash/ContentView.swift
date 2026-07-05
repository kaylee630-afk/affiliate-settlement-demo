import SwiftUI

struct ContentView: View {
    @Environment(PayStore.self) private var store
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(switchToPay: { selectedTab = 1 })
                .tabItem { Label("Home", systemImage: "house.fill") }.tag(0)
            PaymentView()
                .tabItem { Label("Pay", systemImage: "dollarsign.circle.fill") }.tag(1)
            AffiliateView()
                .tabItem { Label("Earnings", systemImage: "person.2.fill") }.tag(2)
            HistoryView()
                .tabItem { Label("History", systemImage: "list.bullet.rectangle.fill") }.tag(3)
            ProfileView()
                .tabItem { Label("Account", systemImage: "person.circle.fill") }.tag(4)
        }
    }
}
