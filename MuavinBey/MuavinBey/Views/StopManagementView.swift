import SwiftUI

struct StopManagementView: View {
    @ObservedObject var viewModel: TripViewModel
    @State private var newStopName = ""
    @State private var showingAddStop = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [BusTheme.backgroundLight, BusTheme.primaryOrange.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if let trip = viewModel.currentTrip {
                        if trip.stops.isEmpty {
                            VStack(spacing: 24) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [BusTheme.primaryOrange.opacity(0.2), BusTheme.accentOrange.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: "mappin.circle")
                                        .font(.system(size: 60))
                                        .foregroundColor(BusTheme.primaryOrange)
                                }
                                
                                Text("Henüz durak eklenmedi")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(BusTheme.textPrimary)
                                
                                Text("Durak eklemek için aşağıdaki butona basın")
                                    .font(.subheadline)
                                    .foregroundColor(BusTheme.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(trip.stops) { stop in
                                        let passengerCount = viewModel.getPassengerCountByStop()[stop.id] ?? 0
                                        HStack {
                                            StopBadge(name: stop.name, passengerCount: passengerCount)
                                            
                                            Button(action: {
                                                viewModel.deleteStop(stop)
                                            }) {
                                                Image(systemName: "trash.fill")
                                                    .foregroundColor(BusTheme.errorRed)
                                                    .font(.system(size: 18))
                                                    .padding(12)
                                                    .background(BusTheme.errorRed.opacity(0.1))
                                                    .cornerRadius(8)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                .padding(.vertical)
                            }
                        }
                    } else {
                        VStack(spacing: 24) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [BusTheme.warningYellow.opacity(0.2), BusTheme.warningYellow.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(BusTheme.warningYellow)
                            }
                            
                            Text("Henüz sefer oluşturulmadı")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(BusTheme.textPrimary)
                            
                            Text("Önce 'Yeni Sefer' sekmesinden bir sefer oluşturun")
                                .font(.subheadline)
                                .foregroundColor(BusTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if viewModel.currentTrip != nil {
                            showingAddStop = true
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text("Durak Ekle")
                                .fontWeight(.semibold)
                        }
                    }
                    .buttonStyle(BusPrimaryButtonStyle(isEnabled: viewModel.currentTrip != nil))
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Durak Yönetimi")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddStop) {
                AddStopSheet(viewModel: viewModel, stopName: $newStopName)
            }
        }
    }
    
}

struct AddStopSheet: View {
    @ObservedObject var viewModel: TripViewModel
    @Binding var stopName: String
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
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
                            viewModel.addStop(name: stopName)
                            stopName = ""
                            dismiss()
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                            Text("Kaydet")
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

