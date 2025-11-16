import SwiftUI

struct TripDetailView: View {
    let trip: Trip
    @ObservedObject var viewModel: TripViewModel
    @State private var selectedSeatForStop: Seat?
    @State private var showingStopSelection = false
    @State private var showingTripStatus = false
    @Environment(\.dismiss) var dismiss
    
    // Seferin güncel halini almak için
    private var currentTrip: Trip? {
        viewModel.allTrips.first { $0.id == trip.id }
    }
    
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
                
                if let trip = currentTrip {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Sefer Durumu Butonu
                            if trip.isActive {
                                Button(action: {
                                    showingTripStatus = true
                                }) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(BusTheme.successGreen)
                                                .frame(width: 12, height: 12)
                                            
                                            Circle()
                                                .fill(BusTheme.successGreen.opacity(0.3))
                                                .frame(width: 20, height: 20)
                                        }
                                        
                                        Text("Sefer Devam Ediyor - Durumu Görüntüle")
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                    }
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            colors: [BusTheme.successGreen, BusTheme.successGreen.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(12)
                                }
                                .padding(.horizontal)
                                .padding(.top)
                            } else {
                                Button(action: {
                                    viewModel.startTrip(trip)
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "play.circle.fill")
                                            .font(.title3)
                                        Text("Seferi Başlat")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .buttonStyle(BusPrimaryButtonStyle(isEnabled: true))
                                .padding(.horizontal)
                                .padding(.top)
                            }
                            
                            // Sefer Bilgileri Card
                            VStack(alignment: .leading, spacing: 16) {
                                BusSectionHeader(title: "Sefer Bilgileri", icon: "info.circle.fill")
                                
                                VStack(spacing: 12) {
                                    InfoRow(icon: "car.fill", title: "Araç Plakası", value: trip.vehiclePlate)
                                    InfoRow(icon: "mappin.circle.fill", title: "Güzergah", value: trip.routeDescription)
                                    InfoRow(icon: "clock.fill", title: "Sefer Saati", value: trip.tripTime.isEmpty ? "Belirtilmemiş" : trip.tripTime)
                                    InfoRow(icon: "chair.fill", title: "Koltuk Sayısı", value: "\(trip.seatCount) (\(trip.seatLayout))")
                                    InfoRow(icon: "mappin.circle", title: "Durak Sayısı", value: "\(trip.stops.count)")
                                    InfoRow(icon: "person.fill", title: "Dolu Koltuk", value: "\(trip.occupiedSeatsCount)")
                                }
                            }
                            .busCard()
                            .padding(.horizontal)
                            
                            // Koltuk Yönetimi
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
                                    
                                    Text("Koltuklara durak atamak için önce sefer düzenleme ekranından durak ekleyin")
                                        .font(.subheadline)
                                        .foregroundColor(BusTheme.textSecondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                VStack(alignment: .leading, spacing: 16) {
                                    BusSectionHeader(title: "Koltuk Planlaması", icon: "chair.fill")
                                    
                                    // Bilgi Notu
                                    HStack(spacing: 12) {
                                        Image(systemName: "info.circle.fill")
                                            .foregroundColor(BusTheme.accentBlue)
                                        Text("Koltuk numarasına tıklayarak durak seçin. Uzun basarak dolu/boş yapın.")
                                            .font(.subheadline)
                                            .foregroundColor(BusTheme.textSecondary)
                                    }
                                    .padding()
                                    .background(BusTheme.accentBlue.opacity(0.1))
                                    .cornerRadius(12)
                                    
                                    // Otobüs Görseli
                                    BusSeatLayoutView(
                                        trip: trip,
                                        stops: trip.stops,
                                        onSeatTap: { seat in
                                            selectedSeatForStop = seat
                                            showingStopSelection = true
                                        },
                                        onSeatLongPress: { seat in
                                            updateSeatOccupation(seat)
                                        }
                                    )
                                }
                                .busCard()
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 30)
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
                        
                        Text("Sefer bulunamadı")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(BusTheme.textPrimary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Sefer Detayı")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                // Durak Seçim Popup'ı
                if showingStopSelection,
                   let seat = selectedSeatForStop,
                   let trip = currentTrip {
                    StopSelectionPopup(
                        seat: seat,
                        stops: trip.stops,
                        selectedStopId: seat.stopId,
                        onSelect: { stopId in
                            updateSeat(seat, stopId: stopId)
                            showingStopSelection = false
                        },
                        onDismiss: {
                            showingStopSelection = false
                        }
                    )
                }
            }
            .sheet(isPresented: $showingTripStatus) {
                if let trip = currentTrip {
                    TripStatusView(trip: trip, viewModel: viewModel)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    private func updateSeat(_ seat: Seat, stopId: UUID?) {
        guard let trip = currentTrip else { return }
        
        // ViewModel'deki updateSeat fonksiyonunu kullan
        // Bu fonksiyon hem stopId'yi hem de isOccupied'ı günceller
        // Ancak currentTrip'i güncellemek için trip'i de güncellememiz gerekiyor
        var updatedTrip = trip
        if let index = updatedTrip.seats.firstIndex(where: { $0.id == seat.id }) {
            updatedTrip.seats[index].stopId = stopId
            // Durak atandığında otomatik olarak dolu yap
            if stopId != nil {
                updatedTrip.seats[index].isOccupied = true
            } else {
                // Durak kaldırıldığında boş yap
                updatedTrip.seats[index].isOccupied = false
            }
            viewModel.updateTrip(updatedTrip)
        }
    }
    
    private func updateSeatOccupation(_ seat: Seat) {
        guard var trip = currentTrip else { return }
        
        if let index = trip.seats.firstIndex(where: { $0.id == seat.id }) {
            trip.seats[index].isOccupied.toggle()
            viewModel.updateTrip(trip)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(BusTheme.primaryBlue)
                .frame(width: 24)
            Text(title)
                .foregroundColor(BusTheme.textSecondary)
            Spacer()
            Text(value)
                .foregroundColor(BusTheme.textPrimary)
                .fontWeight(.medium)
        }
        .padding()
        .background(BusTheme.backgroundCard)
        .cornerRadius(12)
    }
}

