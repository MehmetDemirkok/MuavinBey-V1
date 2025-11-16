import SwiftUI
import UIKit

struct StartView: View {
    @ObservedObject var viewModel: TripViewModel
    @State private var vehicleType = "Otobüs"
    @State private var seatLayout = "2+1"
    @State private var seatCount = ""
    @State private var routeStart = ""
    @State private var routeEnd = ""
    @State private var showingError = false
    @State private var showingSuccess = false
    @State private var errorMessage = ""
    
    let vehicleTypes = ["Otobüs", "Midibüs", "Minibüs"]
    let seatLayouts = ["2+1", "2+2"]
    
    var body: some View {
        NavigationStack {
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
                                // Araç Tipi
                                HStack {
                                    Image(systemName: "bus")
                                        .foregroundColor(BusTheme.primaryBlue)
                                        .frame(width: 24)
                                    Text("Araç Tipi")
                                        .foregroundColor(BusTheme.textSecondary)
                                    Spacer()
                                    Picker("", selection: $vehicleType) {
                                        ForEach(vehicleTypes, id: \.self) { type in
                                            Text(type).tag(type)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(BusTheme.primaryBlue)
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
        }
    }
    
    private var isFormValid: Bool {
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
        
        // Sefer oluştur
        viewModel.createTrip(
            vehicleType: vehicleType,
            seatLayout: seatLayout,
            seatCount: count,
            routeStart: routeStart.trimmingCharacters(in: .whitespaces),
            routeEnd: routeEnd.trimmingCharacters(in: .whitespaces)
        )
        
        // Başarı mesajı göster
        showingSuccess = true
        
        // Form'u temizle (opsiyonel - kullanıcı yeni sefer oluşturmak isteyebilir)
        // seatCount = ""
        // routeStart = ""
        // routeEnd = ""
    }
}

