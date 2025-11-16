import SwiftUI

struct TripSummaryView: View {
    @ObservedObject var viewModel: TripViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [BusTheme.backgroundLight, BusTheme.successGreen.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if let trip = viewModel.currentTrip {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header Icon
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [BusTheme.successGreen, BusTheme.primaryBlue],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 80, height: 80)
                                        .shadow(color: BusTheme.successGreen.opacity(0.3), radius: 12, x: 0, y: 6)
                                    
                                    Image(systemName: "chart.bar.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                }
                                
                                Text("Sefer Özeti")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(BusTheme.textPrimary)
                            }
                            .padding(.top, 20)
                            
                            // Sefer Bilgileri
                            VStack(alignment: .leading, spacing: 16) {
                                BusSectionHeader(title: "Sefer Bilgileri", icon: "info.circle.fill")
                                
                                VStack(spacing: 12) {
                                    InfoCard(
                                        icon: "numberplate",
                                        title: "Araç Plakası",
                                        value: trip.vehiclePlate,
                                        color: BusTheme.primaryBlue
                                    )
                                    
                                    InfoCard(
                                        icon: "rectangle.grid.2x2",
                                        title: "Koltuk Düzeni",
                                        value: trip.seatLayout,
                                        color: BusTheme.primaryOrange
                                    )
                                    
                                    InfoCard(
                                        icon: "number",
                                        title: "Koltuk Sayısı",
                                        value: "\(trip.seatCount)",
                                        color: BusTheme.accentBlue
                                    )
                                    
                                    InfoCard(
                                        icon: "map.fill",
                                        title: "Güzergah",
                                        value: trip.routeDescription,
                                        color: BusTheme.successGreen
                                    )
                                    
                                    if !trip.tripTime.isEmpty {
                                        InfoCard(
                                            icon: "clock.fill",
                                            title: "Kalkış Saati",
                                            value: trip.tripTime,
                                            color: BusTheme.primaryOrange
                                        )
                                    }
                                }
                            }
                            .busCard()
                            .padding(.horizontal)
                            
                            // Yolcu İstatistikleri
                            VStack(alignment: .leading, spacing: 16) {
                                BusSectionHeader(title: "Yolcu İstatistikleri", icon: "person.2.fill")
                                
                                HStack {
                                    Spacer()
                                    VStack(spacing: 8) {
                                        Text("\(trip.occupiedSeatsCount)")
                                            .font(.system(size: 48, weight: .bold))
                                            .foregroundColor(BusTheme.primaryBlue)
                                        Text("/ \(trip.seatCount) koltuk")
                                            .font(.subheadline)
                                            .foregroundColor(BusTheme.textSecondary)
                                        Text("Dolu")
                                            .font(.caption)
                                            .foregroundColor(BusTheme.textSecondary)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [BusTheme.primaryBlue.opacity(0.1), BusTheme.accentBlue.opacity(0.05)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(16)
                            }
                            .busCard()
                            .padding(.horizontal)
                            
                            // Durak Bazında İnişler
                            if !trip.stops.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    BusSectionHeader(title: "Durak Bazında İnişler", icon: "mappin.circle.fill")
                                    
                                    let passengerCountByStop = viewModel.getPassengerCountByStop()
                                    
                                    if passengerCountByStop.isEmpty {
                                        HStack {
                                            Spacer()
                                            VStack(spacing: 8) {
                                                Image(systemName: "info.circle")
                                                    .font(.system(size: 32))
                                                    .foregroundColor(BusTheme.textSecondary)
                                                Text("Henüz yolcu ataması yapılmamış")
                                                    .font(.subheadline)
                                                    .foregroundColor(BusTheme.textSecondary)
                                            }
                                            Spacer()
                                        }
                                        .padding()
                                    } else {
                                        VStack(spacing: 12) {
                                            ForEach(trip.stops) { stop in
                                                if let count = passengerCountByStop[stop.id], count > 0 {
                                                    StopBadge(name: stop.name, passengerCount: count)
                                                }
                                            }
                                        }
                                    }
                                }
                                .busCard()
                                .padding(.horizontal)
                            }
                            
                            Spacer(minLength: 30)
                        }
                        .padding(.bottom)
                    }
                    .navigationTitle("Sefer Özeti")
                    .navigationBarTitleDisplayMode(.inline)
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
                    .navigationTitle("Sefer Özeti")
                }
            }
        }
    }
}


