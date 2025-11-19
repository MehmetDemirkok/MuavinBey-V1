import SwiftUI

struct TripListView: View {
    @ObservedObject var viewModel: TripViewModel
    @State private var showingDeleteAlert = false
    @State private var tripToDelete: Trip?

    @State private var showingStartSheet = false
    @State private var tripToEdit: Trip?
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [BusTheme.backgroundLight, BusTheme.primaryBlue.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if viewModel.allTrips.isEmpty {
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [BusTheme.primaryBlue.opacity(0.2), BusTheme.accentBlue.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: 60))
                                .foregroundColor(BusTheme.primaryBlue)
                        }
                        
                        Text("Henüz sefer yok")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(BusTheme.textPrimary)
                        
                        Text("Yeni sefer oluşturmak için 'Yeni Sefer' sekmesini kullanın")
                            .font(.subheadline)
                            .foregroundColor(BusTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.allTrips) { trip in
                                TripCard(
                                    trip: trip,
                                    isSelected: viewModel.currentTrip?.id == trip.id,
                                    navigationDestination: TripDetailView(trip: trip, viewModel: viewModel),
                                    onSelect: {
                                        viewModel.selectTrip(trip)
                                    },
                                    onEdit: {
                                        tripToEdit = trip
                                    },
                                    onDelete: {
                                        tripToDelete = trip
                                        showingDeleteAlert = true
                                    },
                                    onDuplicate: {
                                        viewModel.duplicateTrip(trip)
                                    }
                                )
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Seferler")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingStartSheet = true
                    }) {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    }
                }
            }
            .alert("Seferi Sil", isPresented: $showingDeleteAlert) {
                Button("İptal", role: .cancel) { }
                Button("Sil", role: .destructive) {
                    if let trip = tripToDelete {
                        viewModel.deleteTrip(trip)
                    }
                }
            } message: {
                if let trip = tripToDelete {
                    Text("'\(trip.routeDescription)' seferini silmek istediğinize emin misiniz?")
                }
            }
            .sheet(item: $tripToEdit) { trip in
                EditTripView(viewModel: viewModel, trip: trip)
            }
            .sheet(isPresented: $showingStartSheet) {
                StartView(viewModel: viewModel)
            }
        }
    }
}

struct TripCard: View {
    let trip: Trip
    let isSelected: Bool
    let navigationDestination: TripDetailView
    let onSelect: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onDuplicate: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Tıklanabilir üst kısım - NavigationLink
            NavigationLink(destination: navigationDestination) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "car.fill")
                                .foregroundColor(BusTheme.primaryBlue)
                            Text(trip.vehiclePlate)
                                .font(.headline)
                                .foregroundColor(BusTheme.textPrimary)
                            
                            if trip.isCompleted {
                                Text("Tamamlandı")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(BusTheme.successGreen.opacity(0.2))
                                    .foregroundColor(BusTheme.successGreen)
                                    .cornerRadius(8)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(BusTheme.primaryOrange)
                                .font(.caption)
                            Text(trip.routeDescription)
                                .font(.subheadline)
                                .foregroundColor(BusTheme.textSecondary)
                        }
                        
                        HStack(spacing: 16) {
                            Label("\(trip.seatCount) koltuk", systemImage: "chair.fill")
                                .font(.caption)
                                .foregroundColor(BusTheme.textSecondary)
                            
                            Label(trip.seatLayout, systemImage: "rectangle.grid.2x2")
                                .font(.caption)
                                .foregroundColor(BusTheme.textSecondary)
                            
                            Label("\(trip.stops.count) durak", systemImage: "mappin.circle")
                                .font(.caption)
                                .foregroundColor(BusTheme.textSecondary)
                        }
                        
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .foregroundColor(BusTheme.accentBlue)
                                    .font(.caption)
                                Text(trip.shortDate)
                                    .font(.caption)
                                    .foregroundColor(BusTheme.textSecondary)
                            }
                            
                            if !trip.tripTime.isEmpty {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(BusTheme.primaryOrange)
                                        .font(.caption)
                                    Text(trip.tripTime)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(BusTheme.primaryOrange)
                                }
                            }
                        }
                        .padding(.top, 4)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(BusTheme.successGreen)
                            .font(.title2)
                    }
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(BusTheme.textSecondary)
                        .font(.caption)
                }
            }
            .buttonStyle(.plain)
            
            Divider()
            
            // Butonlar - NavigationLink dışında
            HStack(spacing: 12) {
                // Seçili butonu kaldırıldı

                
                Button(action: onEdit) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Düzenle")
                    }
                    .font(.subheadline)
                    .foregroundColor(BusTheme.primaryOrange)
                }
                .buttonStyle(BusSecondaryButtonStyle())
                
                Button(action: onDuplicate) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(BusTheme.accentBlue)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(BusTheme.errorRed)
                }
            }
        }
        .padding()
        .background(BusTheme.backgroundCard)
        .cornerRadius(16)
        .shadow(color: isSelected ? BusTheme.primaryBlue.opacity(0.2) : Color.black.opacity(0.05), radius: isSelected ? 8 : 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? BusTheme.primaryBlue : Color.clear, lineWidth: 2)
        )
    }
}

