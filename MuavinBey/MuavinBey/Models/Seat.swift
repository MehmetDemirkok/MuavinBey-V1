import Foundation

struct Seat: Identifiable, Codable {
    let id: UUID
    var number: Int
    var stopId: UUID?  // ineceği durak
    var isOccupied: Bool
    
    init(id: UUID = UUID(), number: Int, stopId: UUID? = nil, isOccupied: Bool = false) {
        self.id = id
        self.number = number
        self.stopId = stopId
        self.isOccupied = isOccupied
    }
}

