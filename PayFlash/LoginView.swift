import SwiftUI
struct LoginView: View {
    @Binding var isLoggedIn: Bool; @Binding var userRole: String; @Binding var userId: Int
    @State private var email = ""; @State private var password = ""; @State private var name = ""; @State private var isRegistering = false; @State private var selectedRole = "brand"; @State private var errorMsg = ""; @State private var isLoading = false
    let API = "http://192.168.1.233:3000/api"
    var body: some View {
        VStack(spacing: 24) {
            Spacer(); Image("icon").resizable().aspectRatio(contentMode: .fit).frame(width: 100, height: 100)
            Text("PayFlash").font(.system(size: 32, weight: .bold)); Text(isRegistering ? "Create Account" : "Sign In").font(.title3).foregroundColor(.secondary)
            if !errorMsg.isEmpty { Text(errorMsg).font(.caption).foregroundColor(.red).padding(.horizontal) }
            VStack(spacing: 12) {
                if isRegistering { TextField("Name", text: $name).padding().background(Color(.systemGray6)).cornerRadius(10); Picker("Role", selection: $selectedRole) { Text("Brand").tag("brand"); Text("Affiliate").tag("affiliate") }.pickerStyle(.segmented).padding(.horizontal) }
                TextField("Email", text: $email).keyboardType(.emailAddress).autocapitalization(.none).padding().background(Color(.systemGray6)).cornerRadius(10)
                SecureField("Password", text: $password).padding().background(Color(.systemGray6)).cornerRadius(10)
            }.padding(.horizontal, 30)
            Button(action: submit) { HStack { if isLoading { ProgressView() }; Text(isRegistering ? "Create Account" : "Sign In") }.font(.headline).foregroundColor(.white).frame(maxWidth:.infinity).padding(.vertical,16).background(Color.blue).cornerRadius(14) }.padding(.horizontal,30).disabled(isLoading)
            Button(isRegistering ? "Already have an account? Sign In" : "Don't have an account? Register") { withAnimation { isRegistering.toggle(); errorMsg = "" } }.font(.subheadline)
            Spacer()
            VStack(spacing:6) { Text("Demo Accounts").font(.caption).foregroundColor(.secondary); HStack(spacing:12) { Button("Brand Demo") { email="brand@demo.com"; password="demo123"; isRegistering=false }; Button("Affiliate Demo") { email="alice@demo.com"; password="demo123"; isRegistering=false }; Button("Admin") { email="admin@payflash.com"; password="admin123"; isRegistering=false } }.font(.caption2) }.padding(.bottom,30)
        }.background(Color(.systemGroupedBackground))
    }
    func submit() { guard !email.isEmpty, !password.isEmpty else { errorMsg = "Fill all fields"; return }; isLoading = true; errorMsg = ""; let endpoint = isRegistering ? "/register" : "/login"; guard let url = URL(string: API + endpoint) else { return }; var req = URLRequest(url: url); req.httpMethod = "POST"; req.setValue("application/json", forHTTPHeaderField: "Content-Type"); var body: [String: Any] = ["email": email, "password": password]; if isRegistering { body["name"] = name.isEmpty ? String(email.split(separator: "@").first ?? "") : name; body["role"] = selectedRole }; req.httpBody = try? JSONSerialization.data(withJSONObject: body); URLSession.shared.dataTask(with: req) { data, _, error in DispatchQueue.main.async { isLoading = false; guard let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { errorMsg = "Network error"; return }; if let user = json["user"] as? [String: Any] { userId = user["id"] as? Int ?? 1; userRole = user["role"] as? String ?? "brand"; withAnimation { isLoggedIn = true } } else if let err = json["error"] as? String { errorMsg = err } } }.resume() }
}
