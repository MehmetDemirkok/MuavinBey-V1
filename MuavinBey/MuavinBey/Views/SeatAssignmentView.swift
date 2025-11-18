import SwiftUI

struct SeatAssignmentView: View {
    @ObservedObject var viewModel: TripViewModel
    @State private var selectedSeatForStop: Seat?
    @State private var showingStopSelection = false
    
    var body: some View {
        NavigationView {
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
                            
                            Text("Koltuklara durak atamak için önce sefer oluştururken durak ekleyin")
                                .font(.subheadline)
                                .foregroundColor(BusTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .navigationTitle("Koltuk Yönetimi")
                    } else {
                        ScrollView {
                            VStack(spacing: 20) {
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
                                .padding(.horizontal)
                                
                                // Otobüs Görseli
                                BusSeatLayoutView(
                                    trip: trip,
                                    stops: trip.stops,
                                    onSeatTap: { seat in
                                        selectedSeatForStop = seat
                                        showingStopSelection = true
                                    },
                                    onSeatLongPress: { seat in
                                        viewModel.toggleSeatOccupation(seat)
                                    }
                                )
                            }
                            .padding(.vertical)
                        }
                        .navigationTitle("Koltuk Yönetimi")
                        .navigationBarTitleDisplayMode(.inline)
                        .overlay {
                            // Durak Seçim Popup'ı
                            if showingStopSelection,
                               let seat = selectedSeatForStop {
                                StopSelectionPopup(
                                    seat: seat,
                                    stops: trip.stops,
                                    selectedStopId: seat.stopId,
                                    onSelect: { stopId in
                                        viewModel.updateSeat(seat, stopId: stopId)
                                        showingStopSelection = false
                                    },
                                    onDismiss: {
                                        showingStopSelection = false
                                    }
                                )
                            }
                        }
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

// Popup versiyonu - sayfa değişmeden açılır
struct StopSelectionPopup: View {
    let seat: Seat
    let stops: [Stop]
    let selectedStopId: UUID?
    let onSelect: (UUID?) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Arka plan - tıklanabilir ve yarı saydam
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            // Popup içeriği
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            SeatBadge(number: seat.number, isOccupied: seat.isOccupied)
                            Text("Koltuk \(seat.number)")
                                .font(.headline)
                                .foregroundColor(BusTheme.textPrimary)
                        }
                        Text("İneceği durak seçin")
                            .font(.subheadline)
                            .foregroundColor(BusTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(BusTheme.textSecondary)
                    }
                }
                .padding()
                .background(BusTheme.backgroundCard)
                
                // Duraklar listesi
                ScrollView {
                    VStack(spacing: 12) {
                        Button(action: {
                            onSelect(nil)
                        }) {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(BusTheme.textSecondary)
                                Text("Durak Seçilmedi")
                                    .foregroundColor(BusTheme.textPrimary)
                                Spacer()
                                if selectedStopId == nil {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(BusTheme.successGreen)
                                }
                            }
                            .padding()
                            .background(BusTheme.backgroundCard)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedStopId == nil ? BusTheme.primaryBlue : Color.clear, lineWidth: 2)
                            )
                        }
                        
                        ForEach(stops) { stop in
                            Button(action: {
                                onSelect(stop.id)
                            }) {
                                HStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(BusTheme.primaryOrange)
                                    Text(stop.name)
                                        .foregroundColor(BusTheme.textPrimary)
                                    Spacer()
                                    if selectedStopId == stop.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(BusTheme.successGreen)
                                    }
                                }
                                .padding()
                                .background(BusTheme.backgroundCard)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedStopId == stop.id ? BusTheme.primaryBlue : Color.clear, lineWidth: 2)
                                )
                            }
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: 400)
                .background(BusTheme.backgroundLight)
            }
            .frame(maxWidth: 350)
            .background(BusTheme.backgroundCard)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding()
        }
    }
}

// Eski sheet versiyonu (başka yerlerde kullanılıyorsa)
struct StopSelectionSheet: View {
    let seat: Seat
    let stops: [Stop]
    let selectedStopId: UUID?
    let onSelect: (UUID?) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [BusTheme.backgroundLight, BusTheme.primaryOrange.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        SeatBadge(number: seat.number, isOccupied: seat.isOccupied)
                        
                        Text("Koltuk \(seat.number) için durak seçin")
                            .font(.headline)
                            .foregroundColor(BusTheme.textPrimary)
                    }
                    .padding(.top, 40)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            Button(action: {
                                onSelect(nil)
                            }) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(BusTheme.textSecondary)
                                    Text("Durak Seçilmedi")
                                        .foregroundColor(BusTheme.textPrimary)
                                    Spacer()
                                    if selectedStopId == nil {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(BusTheme.successGreen)
                                    }
                                }
                                .padding()
                                .background(BusTheme.backgroundCard)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedStopId == nil ? BusTheme.primaryBlue : Color.clear, lineWidth: 2)
                                )
                            }
                            
                            ForEach(stops) { stop in
                                Button(action: {
                                    onSelect(stop.id)
                                }) {
                                    HStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(BusTheme.primaryOrange)
                                        Text(stop.name)
                                            .foregroundColor(BusTheme.textPrimary)
                                        Spacer()
                                        if selectedStopId == stop.id {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(BusTheme.successGreen)
                                        }
                                    }
                                    .padding()
                                    .background(BusTheme.backgroundCard)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedStopId == stop.id ? BusTheme.primaryBlue : Color.clear, lineWidth: 2)
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Durak Seç")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                    .tint(BusTheme.primaryBlue)
                }
            }
        }
    }
}

