import SwiftUI

struct TripStatusView: View {
    let trip: Trip
    @ObservedObject var viewModel: TripViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingArrivalConfirmation = false
    @State private var stopToArrive: Stop?
    
    // Seferin güncel halini almak için
    private var currentTrip: Trip? {
        viewModel.allTrips.first { $0.id == trip.id }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [BusTheme.backgroundLight, BusTheme.primaryBlue.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if let trip = currentTrip {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Durum Göstergesi
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [BusTheme.successGreen, BusTheme.successGreen.opacity(0.7)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 100, height: 100)
                                        .shadow(color: BusTheme.successGreen.opacity(0.3), radius: 12, x: 0, y: 6)
                                    
                                    Image(systemName: "bus.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                }
                                
                                Text("Sefer Devam Ediyor")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(BusTheme.textPrimary)
                                
                                Text("\(trip.vehiclePlate)")
                                    .font(.headline)
                                    .foregroundColor(BusTheme.textSecondary)
                                
                                Text(trip.routeDescription)
                                    .font(.subheadline)
                                    .foregroundColor(BusTheme.textSecondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(BusTheme.backgroundCard)
                            .cornerRadius(20)
                            .padding(.horizontal)
                            .padding(.top)
                            
                            // İstatistikler
                            VStack(alignment: .leading, spacing: 16) {
                                BusSectionHeader(title: "Anlık Durum", icon: "chart.bar.fill")
                                
                                VStack(spacing: 12) {
                                    StatRow(
                                        icon: "person.fill",
                                        title: "Dolu Koltuk",
                                        value: "\(trip.occupiedSeatsCount)",
                                        color: BusTheme.primaryBlue
                                    )
                                    
                                    StatRow(
                                        icon: "person.slash.fill",
                                        title: "Boş Koltuk",
                                        value: "\(trip.seatCount - trip.occupiedSeatsCount)",
                                        color: BusTheme.textSecondary
                                    )
                                    
                                    StatRow(
                                        icon: "mappin.circle.fill",
                                        title: "Ziyaret Edilen Durak",
                                        value: "\(trip.visitedStops.count) / \(trip.stops.count)",
                                        color: BusTheme.primaryOrange
                                    )
                                }
                            }
                            .busCard()
                            .padding(.horizontal)
                            
                            // Duraklar Listesi
                            VStack(alignment: .leading, spacing: 16) {
                                BusSectionHeader(title: "Duraklar", icon: "mappin.circle.fill")
                                
                                if trip.stops.isEmpty {
                                    Text("Henüz durak eklenmemiş")
                                        .font(.subheadline)
                                        .foregroundColor(BusTheme.textSecondary)
                                        .padding()
                                } else {
                                    VStack(spacing: 12) {
                                        ForEach(trip.stops) { stop in
                                            StopStatusRow(
                                                stop: stop,
                                                isVisited: trip.isStopVisited(stop.id),
                                                isNext: trip.nextStop?.id == stop.id,
                                                onArrive: {
                                                    stopToArrive = stop
                                                    showingArrivalConfirmation = true
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                            .busCard()
                            .padding(.horizontal)
                            
                            // Sefer Bitir Butonu
                            Button(action: {
                                viewModel.endTrip(trip)
                                dismiss()
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "stop.circle.fill")
                                        .font(.title3)
                                    Text("Seferi Bitir")
                                        .fontWeight(.semibold)
                                }
                            }
                            .buttonStyle(BusPrimaryButtonStyle(isEnabled: true))
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationTitle("Sefer Durumu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Kapat") {
                        dismiss()
                    }
                    .tint(BusTheme.primaryBlue)
                }
            }
            .alert("Durağa Varıldı", isPresented: $showingArrivalConfirmation) {
                Button("İptal", role: .cancel) {
                    stopToArrive = nil
                }
                Button("Onayla") {
                    if let stop = stopToArrive,
                       let trip = currentTrip {
                        viewModel.arriveAtStop(stop.id, for: trip)
                    }
                    stopToArrive = nil
                }
            } message: {
                if let stop = stopToArrive {
                    Text("'\(stop.name)' durağına varıldı. Bu durağa inen yolcuların koltukları otomatik olarak boşaltılacak.")
                }
            }
        }
    }
}

struct StopStatusRow: View {
    let stop: Stop
    let isVisited: Bool
    let isNext: Bool
    let onArrive: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Durum İkonu
            ZStack {
                Circle()
                    .fill(
                        isVisited ?
                        BusTheme.successGreen.opacity(0.2) :
                        (isNext ? BusTheme.primaryOrange.opacity(0.2) : BusTheme.textSecondary.opacity(0.1))
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: isVisited ? "checkmark.circle.fill" : (isNext ? "mappin.circle.fill" : "circle"))
                    .foregroundColor(
                        isVisited ?
                        BusTheme.successGreen :
                        (isNext ? BusTheme.primaryOrange : BusTheme.textSecondary)
                    )
                    .font(.system(size: 20))
            }
            
            // Durak Adı
            VStack(alignment: .leading, spacing: 4) {
                Text(stop.name)
                    .font(.body)
                    .fontWeight(isNext ? .semibold : .regular)
                    .foregroundColor(BusTheme.textPrimary)
                
                if isVisited {
                    Text("Varıldı")
                        .font(.caption)
                        .foregroundColor(BusTheme.successGreen)
                } else if isNext {
                    Text("Sonraki Durak")
                        .font(.caption)
                        .foregroundColor(BusTheme.primaryOrange)
                } else {
                    Text("Bekleniyor")
                        .font(.caption)
                        .foregroundColor(BusTheme.textSecondary)
                }
            }
            
            Spacer()
            
            // Varış Butonu
            if !isVisited {
                Button(action: onArrive) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Varıldı")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            colors: [BusTheme.primaryOrange, BusTheme.accentOrange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(BusTheme.backgroundCard)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isNext ? BusTheme.primaryOrange : Color.clear, lineWidth: 2)
        )
    }
}

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            Text(title)
                .foregroundColor(BusTheme.textSecondary)
            Spacer()
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding()
        .background(BusTheme.backgroundCard)
        .cornerRadius(12)
    }
}

