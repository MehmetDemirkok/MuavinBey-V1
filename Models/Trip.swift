import Foundation

struct Trip: Identifiable, Codable {
    let id: UUID
    var vehicleType: String
    var seatLayout: String  // "2+1" or "2+2"
    var seatCount: Int
    var routeStart: String
    var routeEnd: String
    var stops: [Stop]
    var seats: [Seat]
    
    init(
        id: UUID = UUID(),
        vehicleType: String,
        seatLayout: String,
        seatCount: Int,
        routeStart: String,
        routeEnd: String,
        stops: [Stop] = [],
        seats: [Seat] = []
    ) {
        self.id = id
        self.vehicleType = vehicleType
        self.seatLayout = seatLayout
        self.seatCount = seatCount
        self.routeStart = routeStart
        self.routeEnd = routeEnd
        self.stops = stops
        self.seats = seats
    }
    
    // Computed properties
    var occupiedSeatsCount: Int {
        seats.filter { $0.isOccupied }.count
    }
    
    var routeDescription: String {
        "\(routeStart) → \(routeEnd)"
    }
}

