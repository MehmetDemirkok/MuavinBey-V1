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
        vehiclePlate: String,
        seatLayout: String,
        seatCount: Int,
        routeStart: String,
        routeEnd: String,
        tripTime: String,
        stops: [Stop] = []
    ) {
        let seats = (1...seatCount).map { Seat(number: $0) }
        
        let trip = Trip(
            vehiclePlate: vehiclePlate,
            seatLayout: seatLayout,
            seatCount: seatCount,
            routeStart: routeStart,
            routeEnd: routeEnd,
            tripTime: tripTime,
            stops: stops,
            seats: seats,
            createdAt: Date(),
            isActive: false,
            visitedStops: []
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
            vehiclePlate: trip.vehiclePlate,
            seatLayout: trip.seatLayout,
            seatCount: trip.seatCount,
            routeStart: trip.routeStart,
            routeEnd: trip.routeEnd,
            tripTime: trip.tripTime,
            stops: trip.stops,
            seats: trip.seats.map { Seat(number: $0.number, stopId: $0.stopId, isOccupied: false) },
            createdAt: Date(),
            isActive: false,
            visitedStops: []
        )
        saveTripToList(newTrip)
    }
    
    // MARK: - Trip Status Management
    func startTrip(_ trip: Trip) {
        var updatedTrip = trip
        updatedTrip.isActive = true
        updatedTrip.visitedStops = []
        updateTrip(updatedTrip)
    }
    
    func arriveAtStop(_ stopId: UUID, for trip: Trip) {
        var updatedTrip = trip
        
        // Durağı ziyaret edilenler listesine ekle
        if !updatedTrip.visitedStops.contains(stopId) {
            updatedTrip.visitedStops.append(stopId)
        }
        
        // Bu durağa inen yolcuların koltuklarını boşalt
        updatedTrip.seats = updatedTrip.seats.map { seat in
            var updatedSeat = seat
            if seat.stopId == stopId && seat.isOccupied {
                updatedSeat.isOccupied = false
                updatedSeat.stopId = nil
            }
            return updatedSeat
        }
        
        updateTrip(updatedTrip)
    }
    
    func endTrip(_ trip: Trip) {
        var updatedTrip = trip
        updatedTrip.isActive = false
        updatedTrip.visitedStops = []
        updateTrip(updatedTrip)
    }
    
    func updateTripById(_ tripId: UUID, update: (inout Trip) -> Void) {
        if let index = allTrips.firstIndex(where: { $0.id == tripId }) {
            var trip = allTrips[index]
            update(&trip)
            allTrips[index] = trip
            saveAllTrips()
            
            if currentTrip?.id == tripId {
                currentTrip = trip
                saveCurrentTrip()
            }
        }
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
            // Durak atandığında otomatik olarak dolu yap
            if stopId != nil {
                trip.seats[index].isOccupied = true
            } else {
                // Durak kaldırıldığında boş yap
                trip.seats[index].isOccupied = false
            }
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

