import SwiftUI
import UIKit

struct EditTripView: View {
    @ObservedObject var viewModel: TripViewModel
    let trip: Trip
    
    @State private var vehiclePlate: String
    @State private var seatLayout: String
    @State private var seatCount: String
    @State private var routeStart: String
    @State private var routeEnd: String
    @State private var stops: [Stop]
    @State private var newStopName = ""
    @State private var showingAddStop = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingSuccess = false
    
    @Environment(\.dismiss) var dismiss
    
    let seatLayouts = ["2+1", "2+2"]
    
    init(viewModel: TripViewModel, trip: Trip) {
        self.viewModel = viewModel
        self.trip = trip
        _vehiclePlate = State(initialValue: trip.vehiclePlate)
        _seatLayout = State(initialValue: trip.seatLayout)
        _seatCount = State(initialValue: "\(trip.seatCount)")
        _routeStart = State(initialValue: trip.routeStart)
        _routeEnd = State(initialValue: trip.routeEnd)
        _stops = State(initialValue: trip.stops)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [BusTheme.backgroundLight, BusTheme.primaryOrange.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [BusTheme.primaryOrange, BusTheme.accentOrange],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                    .shadow(color: BusTheme.primaryOrange.opacity(0.3), radius: 12, x: 0, y: 6)
                                
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Sefer Düzenle")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(BusTheme.textPrimary)
                        }
                        .padding(.top, 20)
                        
                        // Araç Bilgileri
                        VStack(alignment: .leading, spacing: 16) {
                            BusSectionHeader(title: "Araç Bilgileri", icon: "car.fill")
                            
                            VStack(spacing: 16) {
                                HStack {
                                    Image(systemName: "numberplate")
                                        .foregroundColor(BusTheme.primaryBlue)
                                        .frame(width: 24)
                                    Text("Araç Plakası")
                                        .foregroundColor(BusTheme.textSecondary)
                                    Spacer()
                                    TextField("Örn: 34 ABC 123", text: $vehiclePlate)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width: 150)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(BusTheme.primaryBlue.opacity(0.1))
                                        .cornerRadius(8)
                                        .autocapitalization(.allCharacters)
                                }
                                .padding()
                                .background(BusTheme.backgroundCard)
                                .cornerRadius(12)
                                
                                HStack {
                                    Image(systemName: "rectangle.grid.2x2")
                                        .foregroundColor(BusTheme.primaryOrange)
                                        .frame(width: 24)
                                    Text("Koltuk Düzeni")
                                        .foregroundColor(BusTheme.textSecondary)
                                    Spacer()
                                    Picker("", selection: $seatLayout) {
                                        ForEach(seatLayouts, id: \.self) { layout in
                                            Text(layout).tag(layout)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(BusTheme.primaryBlue)
                                }
                                .padding()
                                .background(BusTheme.backgroundCard)
                                .cornerRadius(12)
                                
                                HStack {
                                    Image(systemName: "number")
                                        .foregroundColor(BusTheme.accentBlue)
                                        .frame(width: 24)
                                    Text("Koltuk Sayısı")
                                        .foregroundColor(BusTheme.textSecondary)
                                    Spacer()
                                    TextField("Örn: 45", text: $seatCount)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width: 100)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(BusTheme.primaryBlue.opacity(0.1))
                                        .cornerRadius(8)
                                }
                                .padding()
                                .background(BusTheme.backgroundCard)
                                .cornerRadius(12)
                            }
                        }
                        .busCard()
                        .padding(.horizontal)
                        
                        // Güzergah
                        VStack(alignment: .leading, spacing: 16) {
                            BusSectionHeader(title: "Güzergah", icon: "map.fill")
                            
                            VStack(spacing: 16) {
                                HStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(BusTheme.successGreen)
                                        .frame(width: 24)
                                    TextField("Başlangıç", text: $routeStart)
                                        .textFieldStyle(.plain)
                                }
                                .padding()
                                .background(BusTheme.backgroundCard)
                                .cornerRadius(12)
                                
                                Image(systemName: "arrow.down")
                                    .foregroundColor(BusTheme.primaryBlue)
                                    .font(.title3)
                                
                                HStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(BusTheme.errorRed)
                                        .frame(width: 24)
                                    TextField("Bitiş", text: $routeEnd)
                                        .textFieldStyle(.plain)
                                }
                                .padding()
                                .background(BusTheme.backgroundCard)
                                .cornerRadius(12)
                            }
                        }
                        .busCard()
                        .padding(.horizontal)
                        
                        // Duraklar
                        VStack(alignment: .leading, spacing: 16) {
                            BusSectionHeader(title: "Duraklar", icon: "mappin.circle.fill")
                            
                            if stops.isEmpty {
                                Text("Henüz durak eklenmedi")
                                    .font(.subheadline)
                                    .foregroundColor(BusTheme.textSecondary)
                                    .padding()
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(stops) { stop in
                                        HStack {
                                            Image(systemName: "mappin.circle.fill")
                                                .foregroundColor(BusTheme.primaryOrange)
                                            Text(stop.name)
                                                .font(.body)
                                            Spacer()
                                            Button(action: {
                                                stops.removeAll { $0.id == stop.id }
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(BusTheme.errorRed)
                                            }
                                        }
                                        .padding()
                                        .background(BusTheme.backgroundCard)
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            
                            Button(action: {
                                showingAddStop = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Durak Ekle")
                                }
                                .font(.subheadline)
                                .foregroundColor(BusTheme.primaryBlue)
                            }
                            .buttonStyle(BusSecondaryButtonStyle())
                        }
                        .busCard()
                        .padding(.horizontal)
                        
                        Button(action: {
                            saveTrip()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                                Text("Kaydet")
                                    .fontWeight(.semibold)
                            }
                        }
                        .buttonStyle(BusPrimaryButtonStyle(isEnabled: isFormValid))
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Sefer Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                    .tint(BusTheme.primaryBlue)
                }
            }
            .alert("Hata", isPresented: $showingError) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .alert("Başarılı", isPresented: $showingSuccess) {
                Button("Tamam", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("Sefer başarıyla güncellendi!")
            }
            .sheet(isPresented: $showingAddStop) {
                AddStopSheetForStart(stopName: $newStopName, stops: $stops)
            }
        }
    }
    
    private var isFormValid: Bool {
        !vehiclePlate.isEmpty &&
        !seatCount.isEmpty &&
        !routeStart.isEmpty &&
        !routeEnd.isEmpty &&
        Int(seatCount) != nil &&
        Int(seatCount)! > 0
    }
    
    private func saveTrip() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        guard let count = Int(seatCount), count > 0 else {
            errorMessage = "Geçerli bir koltuk sayısı giriniz"
            showingError = true
            return
        }
        
        guard !routeStart.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Başlangıç noktası boş olamaz"
            showingError = true
            return
        }
        
        guard !routeEnd.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Bitiş noktası boş olamaz"
            showingError = true
            return
        }
        
        guard !vehiclePlate.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Araç plakası boş olamaz"
            showingError = true
            return
        }
        
        var updatedTrip = trip
        updatedTrip.vehiclePlate = vehiclePlate.trimmingCharacters(in: .whitespaces).uppercased()
        updatedTrip.seatLayout = seatLayout
        updatedTrip.seatCount = count
        updatedTrip.routeStart = routeStart.trimmingCharacters(in: .whitespaces)
        updatedTrip.routeEnd = routeEnd.trimmingCharacters(in: .whitespaces)
        updatedTrip.stops = stops
        
        // Koltuk sayısı değiştiyse güncelle
        if count != trip.seatCount {
            updatedTrip.seats = (1...count).map { Seat(number: $0) }
        }
        
        viewModel.updateTrip(updatedTrip)
        showingSuccess = true
    }
}

