import SwiftUI
struct HomeView: View {
    @Environment(PayStore.self) private var store; var switchToPay: () -> Void = {}
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 20)
                    Image("icon").resizable().aspectRatio(contentMode: .fit).frame(width: 100, height: 100)
                    Text("Welcome to PayFlash").font(.title2).fontWeight(.bold)
                    Text("Cross-border affiliate settlement on Base L2").font(.subheadline).foregroundColor(.secondary)
                    HStack(spacing: 12) { statBox("$\(Int(store.totalSettled))", "Settled", .green); statBox("\(store.txCount)", "Payments", .blue); statBox("\(Set(store.settlements.map(\.affiliateID)).count)", "Affiliates", .orange) }
                    Button(action: switchToPay) { HStack { Image(systemName:"dollarsign.circle.fill").font(.title3); VStack(alignment:.leading) { Text("New Settlement").font(.headline).foregroundColor(.primary); Text("Pay an affiliate commission").font(.caption).foregroundColor(.secondary) }; Spacer(); Image(systemName:"arrow.right.circle.fill").font(.title2).foregroundColor(.blue) }.padding().background(RoundedRectangle(cornerRadius:14).fill(Color(.systemBackground))) }.buttonStyle(.plain)
                    VStack(alignment:.leading,spacing:8) { Text("Recent Activity".uppercased()).font(.caption).foregroundColor(.secondary).tracking(1); ForEach(store.settlements.prefix(5)) { tx in let p = store.payees.first { $0.id == tx.affiliateID } ?? store.payees[0]; HStack(spacing:10) { Circle().fill(p.color).frame(width:32,height:32).overlay(Text(String(tx.name.prefix(1))).font(.caption).fontWeight(.bold).foregroundColor(.white)); VStack(alignment:.leading,spacing:1) { Text(tx.name).font(.subheadline).fontWeight(.medium); Text("$\(tx.orderAmount, specifier: "%.2f")").font(.caption).foregroundColor(.secondary) }; Spacer(); Text("+$\(tx.commission, specifier: "%.2f")").font(.subheadline).fontWeight(.bold).foregroundColor(.green) }.padding(.vertical,4); Divider() } }.padding().background(RoundedRectangle(cornerRadius:14).fill(Color(.systemBackground)))
                }.padding()
            }.background(Color(.systemGroupedBackground)).navigationTitle("PayFlash").navigationBarTitleDisplayMode(.inline)
        }
    }
    func statBox(_ v: String, _ l: String, _ c: Color) -> some View { VStack(spacing:4) { Text(v).font(.title3).fontWeight(.bold).foregroundColor(c); Text(l).font(.caption2).foregroundColor(.secondary).textCase(.uppercase) }.frame(maxWidth:.infinity).padding(.vertical,12).background(RoundedRectangle(cornerRadius:12).fill(Color(.systemBackground))) }
}
