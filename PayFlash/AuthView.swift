import SwiftUI; import LocalAuthentication
struct AuthView: View {
    @Binding var isUnlocked: Bool; @State private var errorMsg = ""; @State private var isAuthenticating = false
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.05, green: 0.05, blue: 0.15), Color(red: 0.02, green: 0.02, blue: 0.08)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack(spacing: 32) {
                Spacer(); Image("icon").resizable().aspectRatio(contentMode: .fit).frame(width: 100, height: 100); Text("PayFlash").font(.system(size: 36, weight: .bold)).foregroundColor(.white); Spacer()
                if !errorMsg.isEmpty { Text(errorMsg).font(.caption).foregroundColor(.red) }
                Button(action: authenticate) { HStack(spacing: 12) { Image(systemName: biometricIcon).font(.title2); Text("Unlock with \(biometricName)").font(.headline) }.foregroundColor(.white).frame(maxWidth:.infinity).padding(.vertical,18).background(RoundedRectangle(cornerRadius:16).fill(.white.opacity(0.12))).overlay(RoundedRectangle(cornerRadius:16).stroke(.white.opacity(0.2), lineWidth:1)) }.padding(.horizontal,40).disabled(isAuthenticating)
                Spacer().frame(height:80)
            }
        }.onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { authenticate() } }
    }
    var biometricIcon: String { let ctx = LAContext(); var err: NSError?; return ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err) ? (ctx.biometryType == .faceID ? "faceid" : "touchid") : "lock.shield.fill" }
    var biometricName: String { let ctx = LAContext(); var err: NSError?; return ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err) ? (ctx.biometryType == .faceID ? "Face ID" : "Touch ID") : "Passcode" }
    func authenticate() { let ctx = LAContext(); var err: NSError?; guard ctx.canEvaluatePolicy(.deviceOwnerAuthentication, error: &err) else { withAnimation { isUnlocked = true }; return }; isAuthenticating = true; errorMsg = ""; ctx.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Unlock PayFlash") { success, authErr in DispatchQueue.main.async { isAuthenticating = false; if success { withAnimation(.spring(response: 0.6)) { isUnlocked = true } } else if let e = authErr as? LAError, e.code != .userCancel { errorMsg = e.localizedDescription } } } }
}
