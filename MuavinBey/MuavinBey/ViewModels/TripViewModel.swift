import Foundation
import SwiftUI
import Combine

@MainActor
class TripViewModel: ObservableObject {
    @Published var currentTrip: Trip?
    @Published var allTrips: [Trip] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let storage = TripsStorage.shared
    
    init() {
        loadCurrentTrip()
        loadAllTrips()
    }
    
    // MARK: - Trip Management
    func createTrip(
        vehicleType: String,
        seatLayout: String,
        seatCount: Int,
        routeStart: String,
        routeEnd: String,
        stops: [Stop] = []
    ) {
        let seats = (1...seatCount).map { Seat(number: $0) }
        
        let trip = Trip(
            vehicleType: vehicleType,
            seatLayout: seatLayout,
            seatCount: seatCount,
            routeStart: routeStart,
            routeEnd: routeEnd,
            stops: stops,
            seats: seats
        )
        
        currentTrip = trip
        saveCurrentTrip()
        saveTripToList(trip)
    }
    
    func updateTrip(_ trip: Trip) {
        currentTrip = trip
        saveCurrentTrip()
        updateTripInList(trip)
    }
    
    func deleteTrip(_ trip: Trip) {
        allTrips.removeAll { $0.id == trip.id }
        saveAllTrips()
        
        if currentTrip?.id == trip.id {
            currentTrip = nil
            storage.clearCurrentTrip()
        }
    }
    
    func selectTrip(_ trip: Trip) {
        currentTrip = trip
        saveCurrentTrip()
    }
    
    func duplicateTrip(_ trip: Trip) {
        var newTrip = trip
        newTrip = Trip(
            vehicleType: trip.vehicleType,
            seatLayout: trip.seatLayout,
            seatCount: trip.seatCount,
            routeStart: trip.routeStart,
            routeEnd: trip.routeEnd,
            stops: trip.stops,
            seats: trip.seats.map { Seat(number: $0.number, stopId: $0.stopId, isOccupied: false) }
        )
        saveTripToList(newTrip)
    }
    
    // MARK: - Stop Management
    func addStop(name: String) {
        guard var trip = currentTrip else { return }
        let newStop = Stop(name: name)
        trip.stops.append(newStop)
        currentTrip = trip
        saveCurrentTrip()
    }
    
    func deleteStop(_ stop: Stop) {
        guard var trip = currentTrip else { return }
        trip.stops.removeAll { $0.id == stop.id }
        // Remove stop from seats
        trip.seats = trip.seats.map { seat in
            var updatedSeat = seat
            if updatedSeat.stopId == stop.id {
                updatedSeat.stopId = nil
            }
            return updatedSeat
        }
        currentTrip = trip
        saveCurrentTrip()
    }
    
    func moveStop(from source: IndexSet, to destination: Int) {
        guard var trip = currentTrip else { return }
        trip.stops.move(fromOffsets: source, toOffset: destination)
        currentTrip = trip
        saveCurrentTrip()
    }
    
    // MARK: - Seat Management
    func updateSeat(_ seat: Seat, stopId: UUID?) {
        guard var trip = currentTrip else { return }
        if let index = trip.seats.firstIndex(where: { $0.id == seat.id }) {
            trip.seats[index].stopId = stopId
        }
        currentTrip = trip
        saveCurrentTrip()
    }
    
    func toggleSeatOccupation(_ seat: Seat) {
        guard var trip = currentTrip else { return }
        if let index = trip.seats.firstIndex(where: { $0.id == seat.id }) {
            trip.seats[index].isOccupied.toggle()
        }
        currentTrip = trip
        saveCurrentTrip()
    }
    
    // MARK: - Statistics
    func getPassengerCountByStop() -> [UUID: Int] {
        guard let trip = currentTrip else { return [:] }
        
        var countByStop: [UUID: Int] = [:]
        
        for seat in trip.seats where seat.isOccupied {
            if let stopId = seat.stopId {
                countByStop[stopId, default: 0] += 1
            }
        }
        
        return countByStop
    }
    
    // MARK: - Storage
    private func loadCurrentTrip() {
        currentTrip = storage.loadCurrentTrip()
    }
    
    private func saveCurrentTrip() {
        if let trip = currentTrip {
            storage.saveCurrentTrip(trip)
        }
    }
    
    private func loadAllTrips() {
        allTrips = storage.loadTrips()
    }
    
    private func saveAllTrips() {
        storage.saveTrips(allTrips)
    }
    
    private func saveTripToList(_ trip: Trip) {
        if !allTrips.contains(where: { $0.id == trip.id }) {
            allTrips.append(trip)
        }
        saveAllTrips()
    }
    
    private func updateTripInList(_ trip: Trip) {
        if let index = allTrips.firstIndex(where: { $0.id == trip.id }) {
            allTrips[index] = trip
            saveAllTrips()
        } else {
            saveTripToList(trip)
        }
    }
}

