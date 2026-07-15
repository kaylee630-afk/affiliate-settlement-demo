import SwiftUI

struct HomeView: View {
    @Environment(PayStore.self) private var store
    var switchToSend: () -> Void = {}

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Balance Card
                    VStack(spacing: 8) {
                        Text("Your Balance").font(.caption).foregroundColor(.secondary).textCase(.uppercase)
                        Text("$\(store.balance, specifier: "%.2f")").font(.system(size: 48, weight: .bold))
                        Text("USDC on Base L2").font(.caption).foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemBackground)))

                    // Weekly Chart Card
                    WeekChartView()

                    // Quick Actions
                    HStack(spacing: 16) {
                        Button(action: switchToSend) {
                            VStack(spacing: 8) {
                                Image(systemName: "paperplane.fill").font(.title2)
                                Text("Send").font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
                        }.buttonStyle(.plain)

                        Button(action: {}) {
                            VStack(spacing: 8) {
                                Image(systemName: "arrow.down.doc.fill").font(.title2)
                                Text("Request").font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
                        }.buttonStyle(.plain)
                    }

                    // Recent Activity
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Activity".uppercased()).font(.caption).foregroundColor(.secondary).tracking(1)

                        if store.settlements.isEmpty {
                            Text("No transactions yet").font(.subheadline).foregroundColor(.secondary).padding()
                        } else {
                            ForEach(store.settlements.prefix(5)) { tx in
                                let p = store.payees.first { $0.id == tx.affiliateID } ?? store.payees[0]
                                HStack(spacing: 12) {
                                    Circle().fill(p.color).frame(width: 36, height: 36)
                                        .overlay(Text(String(tx.name.prefix(1))).font(.caption).fontWeight(.bold).foregroundColor(.white))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(tx.name).font(.subheadline).fontWeight(.medium)
                                        Text(tx.time).font(.caption).foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text("$\(tx.commission, specifier: "%.2f")").font(.subheadline).fontWeight(.bold).foregroundColor(.green)
                                }
                                .padding(.vertical, 6)
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("PayFlash")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
