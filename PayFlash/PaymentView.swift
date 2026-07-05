import SwiftUI
struct PaymentView: View {
    @Environment(PayStore.self) private var store; @State private var amountInput = "89.90"
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack { Text("1").font(.caption).fontWeight(.bold).foregroundColor(.white).frame(width:24,height:24).background(Color.blue).clipShape(Circle()); Text("Pick Affiliate").font(.headline) }
                        ForEach(store.payees) { p in
                            Button { store.selectedPayee = p } label: {
                                HStack(spacing:12) { Circle().fill(p.color).frame(width:36,height:36).overlay(Text(String(p.name.prefix(1))).font(.caption).fontWeight(.bold).foregroundColor(.white)); VStack(alignment:.leading,spacing:1) { Text(p.name).font(.subheadline).fontWeight(.medium); Text("\(p.flag) \(p.category)").font(.caption).foregroundColor(.secondary) }; Spacer(); if store.selectedPayee.id == p.id { Image(systemName:"checkmark.circle.fill").foregroundColor(.blue) } }.padding(.horizontal,12).padding(.vertical,8)
                            }.buttonStyle(.plain)
                        }
                    }.padding().background(Color(.systemGray6)).cornerRadius(14)
                    VStack(alignment:.leading,spacing:8) {
                        HStack { Text("2").font(.caption).fontWeight(.bold).foregroundColor(.white).frame(width:24,height:24).background(Color.blue).clipShape(Circle()); Text("Order Amount").font(.headline) }
                        HStack { Text("$").font(.largeTitle).foregroundColor(.secondary); TextField("0.00", text: $amountInput).font(.system(size:40,weight:.bold,design:.monospaced)).keyboardType(.decimalPad).onChange(of:amountInput) { _,v in store.orderAmount = Double(v) ?? 0 } }.padding().background(Color(.systemGray6)).cornerRadius(10)
                    }.padding().background(Color(.systemGray6)).cornerRadius(14)
                    VStack(alignment:.leading,spacing:8) {
                        HStack { Text("3").font(.caption).fontWeight(.bold).foregroundColor(.white).frame(width:24,height:24).background(Color.blue).clipShape(Circle()); Text("Commission Rate").font(.headline) }
                        HStack(spacing:10) { ForEach([5,10,15],id:\.self) { r in Button { store.rate = r } label: { VStack(spacing:2) { Text("\(r)%").font(.title3).fontWeight(.bold); Text(r==5 ? "Standard":r==10 ? "Premium":"VIP").font(.caption2) }.frame(maxWidth:.infinity).padding(.vertical,12).background(store.rate==r ? Color.blue : Color(.systemGray6)).foregroundColor(store.rate==r ? .white : .primary).cornerRadius(10) }.buttonStyle(.plain) } }
                    }.padding().background(Color(.systemGray6)).cornerRadius(14)
                    VStack(alignment:.leading,spacing:8) {
                        VStack(spacing:4) { Text("$\(store.commission, specifier: "%.2f")").font(.system(size:36,weight:.bold)).foregroundColor(.green); Text("USDC · Base L2").font(.caption).foregroundColor(.secondary) }.frame(maxWidth:.infinity).padding(.vertical,20).background(Color(.systemGray6)).cornerRadius(10)
                        Button(action: { store.isProcessing=true; store.settle(); store.isProcessing=false; store.showSuccess=true }) { Text("Settle Now").font(.headline).foregroundColor(.white).frame(maxWidth:.infinity).padding(.vertical,14).background(Color.blue).cornerRadius(12) }
                    }.padding().background(Color(.systemGray6)).cornerRadius(14)
                }.padding()
            }.navigationTitle("New Payment")
        }
    }
}
