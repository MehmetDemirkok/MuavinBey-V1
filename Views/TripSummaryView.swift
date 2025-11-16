import SwiftUI

struct TripSummaryView: View {
    @ObservedObject var viewModel: TripViewModel
    
    var body: some View {
        NavigationStack {
            if let trip = viewModel.currentTrip {
                ScrollView {
                    VStack(spacing: 20) {
                        // Sefer Bilgileri
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sefer Bilgileri")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            InfoRow(label: "Araç Tipi", value: trip.vehicleType)
                            InfoRow(label: "Koltuk Düzeni", value: trip.seatLayout)
                            InfoRow(label: "Koltuk Sayısı", value: "\(trip.seatCount)")
                            InfoRow(label: "Güzergah", value: trip.routeDescription)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Yolcu İstatistikleri
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Yolcu İstatistikleri")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Text("Toplam Yolcu:")
                                    .font(.body)
                                Spacer()
                                Text("\(trip.occupiedSeatsCount) / \(trip.seatCount)")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Durak Bazında İnişler
                        if !trip.stops.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Durak Bazında İnişler")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                let passengerCountByStop = viewModel.getPassengerCountByStop()
                                
                                if passengerCountByStop.isEmpty {
                                    Text("Henüz yolcu ataması yapılmamış")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                } else {
                                    ForEach(trip.stops) { stop in
                                        if let count = passengerCountByStop[stop.id], count > 0 {
                                            HStack {
                                                Image(systemName: "mappin.circle.fill")
                                                    .foregroundColor(.blue)
                                                Text(stop.name)
                                                    .font(.body)
                                                Spacer()
                                                Text("\(count) kişi")
                                                    .font(.headline)
                                                    .foregroundColor(.blue)
                                            }
                                            .padding(.vertical, 4)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("Sefer Özeti")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                VStack {
                    Text("Sefer bulunamadı")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .navigationTitle("Sefer Özeti")
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

