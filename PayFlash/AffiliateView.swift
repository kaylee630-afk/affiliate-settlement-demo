import SwiftUI
struct AffiliateView: View {
    @Environment(PayStore.self) private var store; @State private var selected = 0
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:16) {
                    Picker("Affiliate", selection: $selected) { ForEach(Array(store.payees.enumerated()),id:\.offset) { i,p in Text(p.name).tag(i) } }.pickerStyle(.segmented).padding(.horizontal)
                    let p = store.payees[selected]; let txs = store.settlementsFor(p.id); let total = txs.reduce(0) { $0 + $1.commission }
                    VStack(spacing:4) { Text("Total Earned".uppercased()).font(.caption).foregroundColor(.secondary); Text("$\(total, specifier: "%.0f")").font(.system(size:48,weight:.bold)).foregroundColor(.green) }.frame(maxWidth:.infinity).padding(.vertical,24).background(Color(.systemGray6)).cornerRadius(14)
                    ForEach(txs) { tx in
                        HStack(spacing:10) { Circle().fill(p.color).frame(width:32,height:32).overlay(Text(String(tx.name.prefix(1))).font(.caption).fontWeight(.bold).foregroundColor(.white)); VStack(alignment:.leading,spacing:1) { Text("Order #\(tx.id)").font(.subheadline).fontWeight(.medium); Text("$\(tx.orderAmount, specifier: "%.2f") · \(tx.time)").font(.caption).foregroundColor(.secondary) }; Spacer(); Text("+$\(tx.commission, specifier: "%.2f")").font(.subheadline).fontWeight(.bold).foregroundColor(.green) }.padding(.vertical,4); Divider()
                    }
                }.padding()
            }.navigationTitle("Earnings")
        }
    }
}
