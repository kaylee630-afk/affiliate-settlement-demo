import SwiftUI
struct HistoryView: View {
    @Environment(PayStore.self) private var store
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:16) {
                    HStack(spacing:12) { statBox("$\(Int(store.totalSettled))", "Total", .green); statBox("\(store.txCount)", "Payments", .blue); statBox("\(Set(store.settlements.map(\.affiliateID)).count)", "Affiliates", .orange) }
                    ForEach(store.settlements) { tx in
                        let p = store.payees.first { $0.id == tx.affiliateID } ?? store.payees[0]
                        HStack(spacing:10) { Circle().fill(p.color).frame(width:32,height:32).overlay(Text(String(tx.name.prefix(1))).font(.caption).fontWeight(.bold).foregroundColor(.white)); VStack(alignment:.leading,spacing:1) { Text(tx.name).font(.subheadline).fontWeight(.medium); Text("$\(tx.orderAmount, specifier: "%.2f") · \(tx.time)").font(.caption).foregroundColor(.secondary) }; Spacer(); Text("+$\(tx.commission, specifier: "%.2f")").font(.subheadline).fontWeight(.bold).foregroundColor(.green) }.padding(.vertical,4); Divider()
                    }
                }.padding()
            }.navigationTitle("History")
        }
    }
    func statBox(_ v: String, _ l: String, _ c: Color) -> some View {
        VStack(spacing:4) { Text(v).font(.title3).fontWeight(.bold).foregroundColor(c); Text(l).font(.caption2).foregroundColor(.secondary).textCase(.uppercase) }.frame(maxWidth:.infinity).padding(.vertical,12).background(Color(.systemGray6)).cornerRadius(10)
    }
}
