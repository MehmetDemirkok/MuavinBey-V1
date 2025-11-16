import SwiftUI

struct SeatAssignmentView: View {
    @ObservedObject var viewModel: TripViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [BusTheme.backgroundLight, BusTheme.accentBlue.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if let trip = viewModel.currentTrip {
                    if trip.stops.isEmpty {
                        VStack(spacing: 24) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [BusTheme.accentBlue.opacity(0.2), BusTheme.accentBlue.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                
                                Image(systemName: "mappin.circle")
                                    .font(.system(size: 60))
                                    .foregroundColor(BusTheme.accentBlue)
                            }
                            
                            Text("Önce durak ekleyin")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(BusTheme.textPrimary)
                            
                            Text("Koltuklara durak atamak için önce 'Duraklar' sekmesinden durak ekleyin")
                                .font(.subheadline)
                                .foregroundColor(BusTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationTitle("Koltuk Yönetimi")
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(trip.seats.sorted(by: { $0.number < $1.number })) { seat in
                                    SeatRow(
                                        seat: seat,
                                        stops: trip.stops,
                                        onStopChange: { stopId in
                                            viewModel.updateSeat(seat, stopId: stopId)
                                        },
                                        onToggleOccupation: {
                                            viewModel.toggleSeatOccupation(seat)
                                        }
                                    )
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                        }
                        .navigationTitle("Koltuk Yönetimi")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                } else {
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [BusTheme.warningYellow.opacity(0.2), BusTheme.warningYellow.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(BusTheme.warningYellow)
                        }
                        
                        Text("Henüz sefer oluşturulmadı")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(BusTheme.textPrimary)
                        
                        Text("Önce 'Yeni Sefer' sekmesinden bir sefer oluşturun")
                            .font(.subheadline)
                            .foregroundColor(BusTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle("Koltuk Yönetimi")
                }
            }
        }
    }
}

struct SeatRow: View {
    let seat: Seat
    let stops: [Stop]
    let onStopChange: (UUID?) -> Void
    let onToggleOccupation: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Koltuk Numarası
            SeatBadge(number: seat.number, isOccupied: seat.isOccupied)
            
            // Durak Seçimi
            Menu {
                Button(action: {
                    onStopChange(nil)
                }) {
                    Label("Durak Seçilmedi", systemImage: "xmark.circle")
                }
                
                ForEach(stops) { stop in
                    Button(action: {
                        onStopChange(stop.id)
                    }) {
                        Label(stop.name, systemImage: "mappin.circle.fill")
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(seat.stopId != nil ? BusTheme.primaryOrange : BusTheme.textSecondary)
                        .font(.system(size: 18))
                    
                    Text(selectedStopName)
                        .foregroundColor(BusTheme.textPrimary)
                        .fontWeight(seat.stopId != nil ? .medium : .regular)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundColor(BusTheme.textSecondary)
                }
                .padding()
                .background(BusTheme.backgroundCard)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(seat.stopId != nil ? BusTheme.primaryOrange.opacity(0.3) : BusTheme.primaryBlue.opacity(0.2), lineWidth: 1)
                )
            }
            
            // Dolu/Boş Toggle
            Toggle("", isOn: Binding(
                get: { seat.isOccupied },
                set: { _ in onToggleOccupation() }
            ))
            .labelsHidden()
            .tint(BusTheme.primaryBlue)
        }
        .padding()
        .background(BusTheme.backgroundCard)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var selectedStopName: String {
        if let stopId = seat.stopId,
           let stop = stops.first(where: { $0.id == stopId }) {
            return stop.name
        }
        return "Durak Seç"
    }
}

