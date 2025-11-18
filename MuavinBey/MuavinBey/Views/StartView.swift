import SwiftUI
import UIKit

struct StartView: View {
    @ObservedObject var viewModel: TripViewModel
    @State private var vehiclePlate = ""
    @State private var seatLayout = "2+1"
    @State private var seatCount = ""
    @State private var routeStart = ""
    @State private var routeEnd = ""
    @State private var tripTime = ""
    @State private var showingError = false
    @State private var showingSuccess = false
    @State private var errorMessage = ""
    @State private var stops: [Stop] = []
    @State private var newStopName = ""
    @State private var showingAddStop = false
    
    let seatLayouts = ["2+1", "2+2"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [BusTheme.backgroundLight, BusTheme.primaryBlue.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Icon
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [BusTheme.primaryBlue, BusTheme.accentBlue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                    .shadow(color: BusTheme.primaryBlue.opacity(0.3), radius: 12, x: 0, y: 6)
                                
                                Image(systemName: "bus.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Yeni Sefer Oluştur")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(BusTheme.textPrimary)
                        }
                        .padding(.top, 20)
                        
                        // Araç Bilgileri Card
                        VStack(alignment: .leading, spacing: 16) {
                            BusSectionHeader(title: "Araç Bilgileri", icon: "car.fill")
                            
                            VStack(spacing: 16) {
                                // Araç Plakası
                                HStack {
                                    Image(systemName: "car.fill")
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
                                
                                // Koltuk Düzeni
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
                                
                                // Koltuk Sayısı
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
                        
                        // Güzergah Card
                        VStack(alignment: .leading, spacing: 16) {
                            BusSectionHeader(title: "Güzergah", icon: "map.fill")
                            
                            VStack(spacing: 16) {
                                // Başlangıç
                                HStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(BusTheme.successGreen)
                                        .frame(width: 24)
                                    TextField("Başlangıç (Örn: Ankara)", text: $routeStart)
                                        .textFieldStyle(.plain)
                                }
                                .padding()
                                .background(BusTheme.backgroundCard)
                                .cornerRadius(12)
                                
                                // Arrow
                                Image(systemName: "arrow.down")
                                    .foregroundColor(BusTheme.primaryBlue)
                                    .font(.title3)
                                
                                // Bitiş
                                HStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(BusTheme.errorRed)
                                        .frame(width: 24)
                                    TextField("Bitiş (Örn: İstanbul)", text: $routeEnd)
                                        .textFieldStyle(.plain)
                                }
                                .padding()
                                .background(BusTheme.backgroundCard)
                                .cornerRadius(12)
                            }
                        }
                        .busCard()
                        .padding(.horizontal)
                        
                        // Sefer Saati Card
                        VStack(alignment: .leading, spacing: 16) {
                            BusSectionHeader(title: "Sefer Saati", icon: "clock.fill")
                            
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(BusTheme.primaryOrange)
                                    .frame(width: 24)
                                Text("Kalkış Saati")
                                    .foregroundColor(BusTheme.textSecondary)
                                Spacer()
                                TextField("Örn: 14:30", text: $tripTime)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 120)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(BusTheme.primaryOrange.opacity(0.1))
                                    .cornerRadius(8)
                                    .keyboardType(.numbersAndPunctuation)
                            }
                            .padding()
                            .background(BusTheme.backgroundCard)
                            .cornerRadius(12)
                        }
                        .busCard()
                        .padding(.horizontal)
                        
                        // Duraklar Card
                        VStack(alignment: .leading, spacing: 16) {
                            BusSectionHeader(title: "Duraklar (Opsiyonel)", icon: "mappin.circle.fill")
                            
                            // Uyarı Metni
                            HStack(spacing: 12) {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(BusTheme.primaryOrange)
                                    .font(.system(size: 18))
                                Text("Yolcuların ineceği durakları ve mola yerlerini eklemeyi unutmayın")
                                    .font(.subheadline)
                                    .foregroundColor(BusTheme.textSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding()
                            .background(BusTheme.primaryOrange.opacity(0.1))
                            .cornerRadius(12)
                            
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
                        
                        // Sefer Oluştur Button
                        Button(action: {
                            createTrip()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                                Text("Sefer Oluştur")
                                    .fontWeight(.semibold)
                            }
                        }
                        .buttonStyle(BusPrimaryButtonStyle(isEnabled: isFormValid))
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Yeni Sefer")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Hata", isPresented: $showingError) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .alert("Başarılı", isPresented: $showingSuccess) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text("Sefer başarıyla oluşturuldu!")
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
    
    private func createTrip() {
        // Klavye'yi kapat
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
        
        // Sefer oluştur
        viewModel.createTrip(
            vehiclePlate: vehiclePlate.trimmingCharacters(in: .whitespaces).uppercased(),
            seatLayout: seatLayout,
            seatCount: count,
            routeStart: routeStart.trimmingCharacters(in: .whitespaces),
            routeEnd: routeEnd.trimmingCharacters(in: .whitespaces),
            tripTime: tripTime.trimmingCharacters(in: .whitespaces),
            stops: stops
        )
        
        // Başarı mesajı göster
        showingSuccess = true
        
        // Form'u temizle - yeni sefer oluşturmaya hazır
        resetForm()
    }
    
    private func resetForm() {
        vehiclePlate = ""
        seatLayout = "2+1"
        seatCount = ""
        routeStart = ""
        routeEnd = ""
        tripTime = ""
        stops = []
    }
}

struct AddStopSheetForStart: View {
    @Binding var stopName: String
    @Binding var stops: [Stop]
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [BusTheme.backgroundLight, BusTheme.primaryOrange.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
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
                        
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        BusSectionHeader(title: "Durak Adı")
                        
                        TextField("Örn: Esenler Otogar", text: $stopName)
                            .focused($isTextFieldFocused)
                            .padding()
                            .background(BusTheme.backgroundCard)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(BusTheme.primaryOrange.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .busCard()
                    .padding(.horizontal)
                    
                    Button(action: {
                        if !stopName.isEmpty {
                            stops.append(Stop(name: stopName))
                            stopName = ""
                            dismiss()
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                            Text("Ekle")
                                .fontWeight(.semibold)
                        }
                    }
                    .buttonStyle(BusPrimaryButtonStyle(isEnabled: !stopName.isEmpty))
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("Yeni Durak")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                    .tint(BusTheme.primaryBlue)
                }
            }
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }
}

