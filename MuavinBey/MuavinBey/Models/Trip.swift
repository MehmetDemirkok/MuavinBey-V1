import Foundation

struct Trip: Identifiable, Codable {
    let id: UUID
    var vehiclePlate: String
    var seatLayout: String  // "2+1" or "2+2"
    var seatCount: Int
    var routeStart: String
    var routeEnd: String
    var tripTime: String  // Sefer saati (örn: "14:30")
    var stops: [Stop]
    var seats: [Seat]
    var createdAt: Date
    var isActive: Bool  // Sefer aktif mi?
    var visitedStops: [UUID]  // Ziyaret edilen duraklar
    var isCompleted: Bool // Sefer tamamlandı mı?
    
    init(
        id: UUID = UUID(),
        vehiclePlate: String,
        seatLayout: String,
        seatCount: Int,
        routeStart: String,
        routeEnd: String,
        tripTime: String = "",
        stops: [Stop] = [],
        seats: [Seat] = [],
        createdAt: Date = Date(),
        isActive: Bool = false,
        visitedStops: [UUID] = [],
        isCompleted: Bool = false
    ) {
        self.id = id
        self.vehiclePlate = vehiclePlate
        self.seatLayout = seatLayout
        self.seatCount = seatCount
        self.routeStart = routeStart
        self.routeEnd = routeEnd
        self.tripTime = tripTime
        self.stops = stops
        self.seats = seats
        self.createdAt = createdAt
        self.isActive = isActive
        self.visitedStops = visitedStops
        self.isCompleted = isCompleted
    }
    
    // Computed properties
    var occupiedSeatsCount: Int {
        seats.filter { $0.isOccupied }.count
    }
    
    var routeDescription: String {
        "\(routeStart) → \(routeEnd)"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: createdAt)
    }
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: createdAt)
    }
    
    // Durak ziyaret edildi mi?
    func isStopVisited(_ stopId: UUID) -> Bool {
        visitedStops.contains(stopId)
    }
    
    // Sonraki durak
    var nextStop: Stop? {
        stops.first { !visitedStops.contains($0.id) }
    }
}

