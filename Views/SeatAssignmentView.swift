import SwiftUI

struct SeatAssignmentView: View {
    @ObservedObject var viewModel: TripViewModel
    
    var body: some View {
        NavigationStack {
            if let trip = viewModel.currentTrip {
                List {
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
                    }
                }
                .navigationTitle("Koltuk Yönetimi")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                VStack {
                    Text("Sefer bulunamadı")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .navigationTitle("Koltuk Yönetimi")
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
            Text("\(seat.number)")
                .font(.headline)
                .frame(width: 50, height: 50)
                .background(seat.isOccupied ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(seat.isOccupied ? .white : .primary)
                .cornerRadius(8)
            
            // Durak Seçimi
            Menu {
                Button("Durak Seçilmedi") {
                    onStopChange(nil)
                }
                
                ForEach(stops) { stop in
                    Button(stop.name) {
                        onStopChange(stop.id)
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "mappin.circle")
                    Text(selectedStopName)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Dolu/Boş Toggle
            Toggle("", isOn: Binding(
                get: { seat.isOccupied },
                set: { _ in onToggleOccupation() }
            ))
            .labelsHidden()
        }
        .padding(.vertical, 4)
    }
    
    private var selectedStopName: String {
        if let stopId = seat.stopId,
           let stop = stops.first(where: { $0.id == stopId }) {
            return stop.name
        }
        return "Durak Seç"
    }
}

