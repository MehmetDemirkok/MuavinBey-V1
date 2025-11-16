import Foundation
import Combine

/// Tüm veriler kullanıcının telefonunda lokal olarak saklanır
/// Hiçbir cloud servisi veya sunucu kullanılmaz
class TripsStorage: ObservableObject {
    static let shared = TripsStorage()
    
    // UserDefaults keys (küçük veriler için)
    private let currentTripKey = "currentTrip"
    
    // FileManager ile JSON dosyası (büyük veriler için)
    private let tripsFileName = "trips.json"
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var tripsFileURL: URL {
        documentsDirectory.appendingPathComponent(tripsFileName)
    }
    
    private init() {}
    
    // MARK: - Current Trip Management (UserDefaults - hızlı erişim için)
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
    
    // MARK: - All Trips Management (FileManager - güvenilir ve büyük veri için)
    /// Tüm seferleri telefonun Documents klasöründe JSON dosyası olarak saklar
    func saveTrips(_ trips: [Trip]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(trips)
            try data.write(to: tripsFileURL, options: [.atomic])
            print("✅ Seferler telefonun Documents klasörüne kaydedildi: \(tripsFileURL.path)")
        } catch {
            print("❌ Seferler kaydedilirken hata oluştu: \(error.localizedDescription)")
            // Fallback: UserDefaults'a kaydet (küçük veriler için)
            if let encoded = try? JSONEncoder().encode(trips) {
                UserDefaults.standard.set(encoded, forKey: "savedTrips_backup")
            }
        }
    }
    
    /// Tüm seferleri telefonun Documents klasöründen yükler
    func loadTrips() -> [Trip] {
        // Önce FileManager'dan yükle
        if FileManager.default.fileExists(atPath: tripsFileURL.path) {
            do {
                let data = try Data(contentsOf: tripsFileURL)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let trips = try decoder.decode([Trip].self, from: data)
                print("✅ Seferler telefonun Documents klasöründen yüklendi: \(trips.count) sefer")
                return trips
            } catch {
                print("❌ Seferler yüklenirken hata oluştu: \(error.localizedDescription)")
            }
        }
        
        // Eğer dosya yoksa, eski UserDefaults'tan yükle (migration için)
        if let data = UserDefaults.standard.data(forKey: "savedTrips"),
           let trips = try? JSONDecoder().decode([Trip].self, from: data) {
            print("✅ Eski veriler UserDefaults'tan yüklendi, yeni sisteme taşınıyor...")
            // Yeni sisteme taşı
            saveTrips(trips)
            // Eski veriyi temizle
            UserDefaults.standard.removeObject(forKey: "savedTrips")
            return trips
        }
        
        // Backup'tan yükle
        if let data = UserDefaults.standard.data(forKey: "savedTrips_backup"),
           let trips = try? JSONDecoder().decode([Trip].self, from: data) {
            print("✅ Backup'tan seferler yüklendi")
            return trips
        }
        
        return []
    }
    
    /// Tüm verileri sil (kullanıcı verilerini temizlemek için)
    func clearAllData() {
        // UserDefaults'ı temizle
        clearCurrentTrip()
        UserDefaults.standard.removeObject(forKey: "savedTrips")
        UserDefaults.standard.removeObject(forKey: "savedTrips_backup")
        
        // Dosyayı sil
        if FileManager.default.fileExists(atPath: tripsFileURL.path) {
            try? FileManager.default.removeItem(at: tripsFileURL)
        }
        
        print("✅ Tüm veriler telefonundan silindi")
    }
}

