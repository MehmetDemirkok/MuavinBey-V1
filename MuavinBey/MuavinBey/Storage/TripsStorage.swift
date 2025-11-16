import Foundation
import Combine

class TripsStorage: ObservableObject {
    static let shared = TripsStorage()
    
    private let tripsKey = "savedTrips"
    private let currentTripKey = "currentTrip"
    
    private init() {}
    
    // MARK: - Current Trip Management
    func saveCurrentTrip(_ trip: Trip) {
        if let encoded = try? JSONEncoder().encode(trip) {
            UserDefaults.standard.set(encoded, forKey: currentTripKey)
        }
    }
    
    func loadCurrentTrip() -> Trip? {
        guard let data = UserDefaults.standard.data(forKey: currentTripKey),
              let trip = try? JSONDecoder().decode(Trip.self, from: data) else {
            return nil
        }
        return trip
    }
    
    func clearCurrentTrip() {
        UserDefaults.standard.removeObject(forKey: currentTripKey)
    }
    
    // MARK: - All Trips Management
    func saveTrips(_ trips: [Trip]) {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: tripsKey)
        }
    }
    
    func loadTrips() -> [Trip] {
        guard let data = UserDefaults.standard.data(forKey: tripsKey),
              let trips = try? JSONDecoder().decode([Trip].self, from: data) else {
            return []
        }
        return trips
    }
}

