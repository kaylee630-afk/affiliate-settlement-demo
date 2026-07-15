import SwiftUI

// MARK: - Data Model
struct DayEarning: Identifiable {
    let id = UUID()
    let label: String
    let dayIndex: Int
    let amount: Double
    let txCount: Int
    let prevWeekAmount: Double
}

// MARK: - Helpers
private func weekStart(_ date: Date) -> Date {
    let cal = Calendar.current
    let wd = cal.component(.weekday, from: date)
    return cal.date(byAdding: .day, value: wd == 1 ? -6 : 2 - wd, to: date) ?? date
}

// MARK: - Main View
struct WeekChartView: View {
    @Environment(PayStore.self) private var store
    @State private var selectedDayID: UUID? = nil
    @State private var showDetail = false
    
    private let labels = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    
    private var weekData: [DayEarning] {
        let cal = Calendar.current
        let mon = weekStart(Date())
        return (0..<5).map { i in
            let day = cal.date(byAdding: .day, value: i, to: mon)!
            let prev = cal.date(byAdding: .day, value: -7, to: day)!
            let txs = store.settlements.filter { cal.isDate($0.timestamp, inSameDayAs: day) }
            let prevTxs = store.settlements.filter { cal.isDate($0.timestamp, inSameDayAs: prev) }
            let amt = txs.reduce(0) { $0 + $1.commission }
            return DayEarning(label: labels[i], dayIndex: i, amount: amt, txCount: txs.count,
                            prevWeekAmount: prevTxs.reduce(0) { $0 + $1.commission })
        }
    }
    
    private var selectedDay: DayEarning? {
        weekData.first { $0.id == selectedDayID }
    }
    
    private var maxAmount: Double {
        max(weekData.map(\.amount).max() ?? 1, 1)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Text("This Week")
                    .font(.headline)
                Spacer()
                Text("Mon – Fri")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)
            
            // Bar Chart
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(weekData) { day in
                    BarView(
                        day: day,
                        isSelected: selectedDayID == day.id,
                        maxAmount: maxAmount
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedDayID = selectedDayID == day.id ? nil : day.id
                        }
                    }
                }
            }
            .frame(height: 140)
            .padding(.vertical, 8)
            
            // Detail Summary (only when selected)
            if let day = selectedDay {
                DayDetailSummary(day: day)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onTapGesture { showDetail = true }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .sheet(isPresented: $showDetail) {
            if let day = selectedDay {
                DayDetailSheet(day: day, isPresented: $showDetail)
            }
        }
    }
}

// MARK: - Bar View
struct BarView: View {
    let day: DayEarning
    let isSelected: Bool
    let maxAmount: Double
    
    private var barHeight: CGFloat {
        maxAmount > 0 ? CGFloat(day.amount / maxAmount) * 100 : 4
    }
    
    var body: some View {
        VStack(spacing: 6) {
            // Amount label (only when selected)
            if isSelected {
                Text("$\(Int(day.amount))")
                    .font(.caption2.bold())
                    .foregroundColor(.blue)
                    .transition(.opacity)
            }
            
            // Bar
            RoundedRectangle(cornerRadius: 6)
                .fill(isSelected
                    ? LinearGradient(colors: [.blue, .blue.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                    : LinearGradient(colors: [Color(.systemGray4), Color(.systemGray5)], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: 32, height: max(barHeight, 4))
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .shadow(color: isSelected ? .blue.opacity(0.3) : .clear, radius: 4)
            
            // Day label
            Text(day.label)
                .font(.caption2)
                .foregroundColor(isSelected ? .blue : .secondary)
        }
    }
}

// MARK: - Inline Detail Summary
struct DayDetailSummary: View {
    let day: DayEarning
    
    private var wowChange: Double {
        guard day.prevWeekAmount > 0 else { return 0 }
        return ((day.amount - day.prevWeekAmount) / day.prevWeekAmount) * 100
    }
    
    private var avgOrder: Double {
        day.txCount > 0 ? day.amount / Double(day.txCount) : 0
    }
    
    var body: some View {
        HStack(spacing: 0) {
            summaryItem(title: "Total", value: "$\(Int(day.amount))")
            Divider().frame(height: 36)
            summaryItem(title: "Orders", value: "\(day.txCount)")
            Divider().frame(height: 36)
            summaryItem(title: "Avg", value: "$\(Int(avgOrder))")
            Divider().frame(height: 36)
            summaryItem(title: "vs Last Wk", value: wowChange >= 0 ? "↑\(Int(wowChange))%" : "↓\(Int(abs(wowChange)))%")
                .foregroundColor(wowChange >= 0 ? .green : .red)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private func summaryItem(title: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.subheadline.bold())
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Bottom Sheet Detail
struct DayDetailSheet: View {
    let day: DayEarning
    @Binding var isPresented: Bool
    
    private var wowChange: Double {
        guard day.prevWeekAmount > 0 else { return 0 }
        return ((day.amount - day.prevWeekAmount) / day.prevWeekAmount) * 100
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Day badge
                    Text(day.label)
                        .font(.title2.bold())
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(20)
                    
                    // Big amount
                    VStack(spacing: 4) {
                        Text("$\(Int(day.amount))")
                            .font(.system(size: 40, weight: .bold))
                        Text("total earnings")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Detail grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        detailCell(icon: "doc.text", title: "Orders", value: "\(day.txCount)", subtitle: "transactions")
                        detailCell(icon: "chart.bar", title: "Avg Order", value: "$\(Int(day.txCount > 0 ? day.amount/Double(day.txCount) : 0))", subtitle: "per transaction")
                        detailCell(icon: "clock", title: "Time Range", value: "24h", subtitle: "single day")
                        detailCell(icon: "arrow.up.arrow.down", title: "vs Last Week", value: wowChange >= 0 ? "↑ \(Int(wowChange))%" : "↓ \(Int(abs(wowChange)))%", subtitle: wowChange >= 0 ? "increase" : "decrease")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { isPresented = false }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    private func detailCell(icon: String, title: String, value: String, subtitle: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}
