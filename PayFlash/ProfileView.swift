import SwiftUI
struct ProfileView: View {
    @Environment(PayStore.self) private var store; @State private var userName = UserDefaults.standard.string(forKey: "pf_user_name") ?? ""; @State private var walletAddress = UserDefaults.standard.string(forKey: "pf_wallet") ?? ""; @FocusState private var focused: Bool
    var body: some View {
        NavigationStack {
            List {
                Section { HStack(spacing:16) { Circle().fill(LinearGradient(colors:[.blue, Color(red:0.39,green:0.40,blue:0.95)],startPoint:.topLeading,endPoint:.bottomTrailing)).frame(width:48,height:48).overlay(Text(userName.prefix(1).uppercased()).font(.title3).fontWeight(.bold).foregroundColor(.white)); VStack(alignment:.leading,spacing:2) { Text(userName.isEmpty ? "PayFlash User" : userName).font(.headline); Text("Brand Account").font(.caption).foregroundColor(.secondary) } } } header: { Text("Profile") }
                Section { HStack { Label("Total Settled", systemImage:"dollarsign.circle"); Spacer(); Text("$\(Int(store.totalSettled))").fontWeight(.bold).foregroundColor(.green) }; HStack { Label("Transactions", systemImage:"list.number"); Spacer(); Text("\(store.txCount)").fontWeight(.bold) } } header: { Text("Account Stats") }
            }.navigationTitle("Account")
        }
    }
}
