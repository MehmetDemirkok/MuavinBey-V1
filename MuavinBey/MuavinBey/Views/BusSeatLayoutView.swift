import SwiftUI

struct BusSeatLayoutView: View {
    let trip: Trip
    let stops: [Stop]
    let onSeatTap: (Seat) -> Void
    let onSeatLongPress: (Seat) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Otobüs Üst Kısmı (Camlar)
            HStack(spacing: 0) {
                ForEach(0..<getColumnsCount(), id: \.self) { _ in
                    Rectangle()
                        .fill(BusTheme.primaryBlue.opacity(0.3))
                        .frame(height: 20)
                        .overlay(
                            Rectangle()
                                .stroke(BusTheme.primaryBlue.opacity(0.5), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 4)
            .padding(.top, 4)
            
            // Otobüs Gövdesi (Koltuklar)
            ScrollView {
                VStack(spacing: 12) {
                    // Koltuk Düzeni
                    if trip.seatLayout == "2+1" {
                        TwoPlusOneLayout(
                            seats: trip.seats.sorted(by: { $0.number < $1.number }),
                            onSeatTap: onSeatTap,
                            onSeatLongPress: onSeatLongPress
                        )
                    } else {
                        TwoPlusTwoLayout(
                            seats: trip.seats.sorted(by: { $0.number < $1.number }),
                            onSeatTap: onSeatTap,
                            onSeatLongPress: onSeatLongPress
                        )
                    }
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(BusTheme.backgroundCard)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            
            // Otobüs Alt Kısmı
            HStack {
                Spacer()
                Text("\(trip.vehiclePlate)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(BusTheme.primaryBlue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(BusTheme.primaryBlue.opacity(0.1))
                    .cornerRadius(8)
                Spacer()
            }
            .padding(.bottom, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [BusTheme.primaryBlue.opacity(0.1), BusTheme.accentBlue.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(BusTheme.primaryBlue.opacity(0.3), lineWidth: 2)
                )
        )
        .padding()
    }
    
    private func getColumnsCount() -> Int {
        if trip.seatLayout == "2+1" {
            return 3
        } else {
            return 4
        }
    }
}

struct TwoPlusOneLayout: View {
    let seats: [Seat]
    let onSeatTap: (Seat) -> Void
    let onSeatLongPress: (Seat) -> Void
    
    var body: some View {
        let rows = (seats.count + 2) / 3 // 2+1 düzeni için 3 sütun
        
        VStack(spacing: 8) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 8) {
                    // Sol taraf (2 koltuk)
                    HStack(spacing: 4) {
                        if row * 3 < seats.count {
                            BusSeatView(seat: seats[row * 3], onTap: onSeatTap, onLongPress: onSeatLongPress)
                        }
                        if row * 3 + 1 < seats.count {
                            BusSeatView(seat: seats[row * 3 + 1], onTap: onSeatTap, onLongPress: onSeatLongPress)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Koridor
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 20)
                    
                    // Sağ taraf (1 koltuk)
                    if row * 3 + 2 < seats.count {
                        BusSeatView(seat: seats[row * 3 + 2], onTap: onSeatTap, onLongPress: onSeatLongPress)
                            .frame(maxWidth: .infinity)
                    } else {
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

struct TwoPlusTwoLayout: View {
    let seats: [Seat]
    let onSeatTap: (Seat) -> Void
    let onSeatLongPress: (Seat) -> Void
    
    var body: some View {
        let rows = (seats.count + 3) / 4 // 2+2 düzeni için 4 sütun
        
        VStack(spacing: 8) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 8) {
                    // Sol taraf (2 koltuk)
                    HStack(spacing: 4) {
                        if row * 4 < seats.count {
                            BusSeatView(seat: seats[row * 4], onTap: onSeatTap, onLongPress: onSeatLongPress)
                        }
                        if row * 4 + 1 < seats.count {
                            BusSeatView(seat: seats[row * 4 + 1], onTap: onSeatTap, onLongPress: onSeatLongPress)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Koridor
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 20)
                    
                    // Sağ taraf (2 koltuk)
                    HStack(spacing: 4) {
                        if row * 4 + 2 < seats.count {
                            BusSeatView(seat: seats[row * 4 + 2], onTap: onSeatTap, onLongPress: onSeatLongPress)
                        }
                        if row * 4 + 3 < seats.count {
                            BusSeatView(seat: seats[row * 4 + 3], onTap: onSeatTap, onLongPress: onSeatLongPress)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct BusSeatView: View {
    let seat: Seat
    let onTap: (Seat) -> Void
    let onLongPress: (Seat) -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            onTap(seat)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        seat.isOccupied ?
                        LinearGradient(
                            colors: [BusTheme.seatOccupied, BusTheme.accentBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [BusTheme.seatEmpty, Color.gray.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(seat.isOccupied ? BusTheme.primaryBlue.opacity(0.5) : Color.gray.opacity(0.3), lineWidth: 1.5)
                    )
                    .shadow(color: seat.isOccupied ? BusTheme.primaryBlue.opacity(0.3) : Color.clear, radius: 4, x: 0, y: 2)
                
                Text("\(seat.number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(seat.isOccupied ? .white : BusTheme.textPrimary)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    onLongPress(seat)
                }
        )
        .onLongPressGesture(minimumDuration: 0.1) {
            isPressed = true
        } onPressingChanged: { pressing in
            isPressed = pressing
        }
    }
}

