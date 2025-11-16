import SwiftUI

struct StartView: View {
    @ObservedObject var viewModel: TripViewModel
    @State private var vehicleType = "Otobüs"
    @State private var seatLayout = "2+1"
    @State private var seatCount = ""
    @State private var routeStart = ""
    @State private var routeEnd = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    let vehicleTypes = ["Otobüs", "Midibüs", "Minibüs"]
    let seatLayouts = ["2+1", "2+2"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Araç Bilgileri")) {
                    Picker("Araç Tipi", selection: $vehicleType) {
                        ForEach(vehicleTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Picker("Koltuk Düzeni", selection: $seatLayout) {
                        ForEach(seatLayouts, id: \.self) { layout in
                            Text(layout).tag(layout)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    HStack {
                        Text("Koltuk Sayısı")
                        Spacer()
                        TextField("Örn: 45", text: $seatCount)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                }
                
                Section(header: Text("Güzergah")) {
                    TextField("Başlangıç (Örn: Ankara)", text: $routeStart)
                    TextField("Bitiş (Örn: İstanbul)", text: $routeEnd)
                }
                
                Section {
                    Button(action: createTrip) {
                        HStack {
                            Spacer()
                            Text("Sefer Oluştur")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(10)
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Yeni Sefer")
            .alert("Hata", isPresented: $showingError) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text(errorMessage)
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
        guard let count = Int(seatCount), count > 0 else {
            errorMessage = "Geçerli bir koltuk sayısı giriniz"
            showingError = true
            return
        }
        
        viewModel.createTrip(
            vehicleType: vehicleType,
            seatLayout: seatLayout,
            seatCount: count,
            routeStart: routeStart,
            routeEnd: routeEnd
        )
    }
}

