import SwiftUI
struct AdminView: View {
    @Environment(PayStore.self) private var store
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Platform Admin").font(.largeTitle).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 12) {
                    adminStat("$\(Int(store.totalSettled))", "Total", .green)
                    adminStat("\(store.txCount)", "Payments", .blue)
                    adminStat("\(Set(store.settlements.map(\.affiliateID)).count)", "Affiliates", .orange)
                }
                ForEach(store.settlements) { tx in
                    let p = store.payees.first { $0.id == tx.affiliateID } ?? store.payees[0]
                    HStack(spacing: 10) {
                        Circle().fill(p.color).frame(width: 32, height: 32).overlay(Text(String(tx.name.prefix(1))).font(.caption).fontWeight(.bold).foregroundColor(.white))
                        VStack(alignment: .leading, spacing: 1) { Text(tx.name).font(.subheadline).fontWeight(.medium); Text("$\(tx.orderAmount, specifier: "%.2f")").font(.caption).foregroundColor(.secondary) }
                        Spacer()
                        Text("+$\(tx.commission, specifier: "%.2f")").font(.subheadline).fontWeight(.bold).foregroundColor(.green)
                    }.padding(.vertical, 4); Divider()
                }
            }.padding()
        }.background(Color(.systemGroupedBackground))
    }
    func adminStat(_ v: String, _ l: String, _ c: Color) -> some View {
        VStack(spacing: 4) { Text(v).font(.title2).fontWeight(.bold).foregroundColor(c); Text(l).font(.caption2).foregroundColor(.secondary).textCase(.uppercase) }.frame(maxWidth: .infinity).padding(.vertical, 12).background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)))
    }
}
