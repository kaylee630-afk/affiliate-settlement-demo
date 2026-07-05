import SwiftUI; import Observation
struct Settlement: Identifiable, Equatable {
    var id: Int; var affiliateID: String; var name: String; var orderAmount: Double; var commission: Double; var time: String; var timestamp = Date()
    static func == (lhs: Settlement, rhs: Settlement) -> Bool { lhs.id == rhs.id }
}
struct Payee: Identifiable { let id: String; let name: String; let category: String; let flag: String; let color: Color }
enum PaymentStep { case selectPayee, enterAmount, chooseRate, confirm }
@Observable class PayStore {
    var selectedPayee = Payee(id: "@alice_cn", name: "Alice Chen", category: "Beauty", flag: "🇭🇰", color: Color(red: 0.39, green: 0.40, blue: 0.95))
    var orderAmount: Double = 89.90; var rate: Int = 5; var balance: Double = 5000; var totalSettled: Double = 0; var txCount: Int = 0; var settlements: [Settlement] = []
    var userRole: String = "brand"; var userId: Int = 1; var currentStep: PaymentStep = .selectPayee; var isProcessing = false; var showSuccess = false; var lastSettlement: Settlement?
    let payees = [
        Payee(id: "@alice_cn", name: "Alice Chen", category: "Beauty", flag: "🇭🇰", color: Color(red: 0.39, green: 0.40, blue: 0.95)),
        Payee(id: "@bob_kr", name: "Bob Park", category: "Tech", flag: "🇰🇷", color: Color(red: 0.55, green: 0.36, blue: 0.95)),
        Payee(id: "@carol_jp", name: "Carol Tanaka", category: "Fashion", flag: "🇯🇵", color: Color(red: 0.66, green: 0.33, blue: 0.97)),
        Payee(id: "@dave_br", name: "Dave Silva", category: "Outdoor", flag: "🇧🇷", color: Color(red: 0.13, green: 0.77, blue: 0.37)),
        Payee(id: "@eve_de", name: "Eve Mueller", category: "Home", flag: "🇩🇪", color: Color(red: 0.96, green: 0.62, blue: 0.04)),
    ]
    var commission: Double { orderAmount * Double(rate) / 100.0 }
    var API: String { "http://192.168.1.233:3000/api/brand/\(userId)/stats" }
    init() { Task { await loadFromAPI() } }
    func loadFromAPI() async {
        guard let url = URL(string: API) else { return }
        do { let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                await MainActor.run {
                    totalSettled = json["totalSettled"] as? Double ?? 0; txCount = json["txCount"] as? Int ?? 0
                    if let recent = json["recentSettlements"] as? [[String: Any]] { settlements = recent.map { s in Settlement(id: s["id"] as? Int ?? 0, affiliateID: s["affiliate_id"] as? String ?? "", name: s["affiliate_name"] as? String ?? "", orderAmount: s["order_amount"] as? Double ?? 0, commission: s["commission"] as? Double ?? 0, time: "recent", timestamp: Date()) } }
                }
            }
        } catch {}
    }
    func settle() {
        let s = Settlement(id: txCount + 1, affiliateID: selectedPayee.id, name: selectedPayee.name, orderAmount: orderAmount, commission: commission, time: "Just now"); balance -= s.commission; totalSettled += s.commission; txCount += 1; lastSettlement = s; settlements.insert(s, at: 0)
        Task {
            guard let url = URL(string: "http://192.168.1.233:3000/api/settle") else { return }
            var req = URLRequest(url: url); req.httpMethod = "POST"; req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody = try? JSONSerialization.data(withJSONObject: ["brand_id": userId, "affiliate_id": selectedPayee.id, "order_amount": orderAmount, "rate": rate])
            let _ = try? await URLSession.shared.data(for: req)
        }
    }
    func settlementsFor(_ id: String) -> [Settlement] { settlements.filter { $0.affiliateID == id } }
}
extension Double { var f2: String { String(format: "%.2f", self) }; var f0: String { String(format: "%.0f", self) } }
