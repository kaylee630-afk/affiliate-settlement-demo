import SwiftUI
@main
struct PayFlashApp: App {
    @State private var store = PayStore()
    @State private var isLoggedIn = false
    @State private var isUnlocked = false
    @State private var userRole = "brand"
    @State private var userId = 1
    var body: some Scene {
        WindowGroup {
            if !isLoggedIn { LoginView(isLoggedIn: $isLoggedIn, userRole: $userRole, userId: $userId) }
            else if !isUnlocked { AuthView(isUnlocked: $isUnlocked) }
            else { ContentView().environment(store).tint(.blue).onAppear { store.userRole = userRole; store.userId = userId } }
        }
    }
}
