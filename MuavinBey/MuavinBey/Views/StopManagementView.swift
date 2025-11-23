import SwiftUI

struct StopManagementView: View {
    @ObservedObject var viewModel: TripViewModel
    @State private var newStopName = ""
    @State private var showingAddStop = false
    
    var body: some View {
        NavigationView {
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
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    var filteredStops: [String] {
        if searchText.isEmpty {
            return LocationData.stops
        } else {
            return LocationData.stops.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BusTheme.backgroundLight
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(BusTheme.textSecondary)
                        
                        TextField("Durak veya Otogar Ara...", text: $searchText)
                            .focused($isSearchFocused)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(BusTheme.textSecondary)
                            }
                        }
                    }
                    .padding()
                    .background(BusTheme.backgroundCard)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding()
                    
                    // List
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            // Custom Add Button
                            if !searchText.isEmpty {
                                Button(action: {
                                    viewModel.addStop(name: searchText)
                                    stopName = ""
                                    dismiss()
                                }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(BusTheme.successGreen)
                                            .font(.title3)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Yeni Ekle: \"\(searchText)\"")
                                                .foregroundColor(BusTheme.textPrimary)
                                                .fontWeight(.semibold)
                                            Text("Listede olmayan bir durak ekle")
                                                .font(.caption)
                                                .foregroundColor(BusTheme.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(BusTheme.textSecondary)
                                            .font(.caption)
                                    }
                                    .padding()
                                    .background(BusTheme.backgroundCard)
                                }
                                
                                Divider()
                                    .padding(.leading, 50)
                            }
                            
                            ForEach(filteredStops, id: \.self) { stop in
                                Button(action: {
                                    viewModel.addStop(name: stop)
                                    stopName = "" // Reset for next time if needed, though we dismiss
                                    dismiss()
                                }) {
                                    HStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(BusTheme.primaryOrange)
                                            .font(.title3)
                                        
                                        Text(stop)
                                            .foregroundColor(BusTheme.textPrimary)
                                            .font(.body)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(BusTheme.textSecondary)
                                            .font(.caption)
                                    }
                                    .padding()
                                    .background(BusTheme.backgroundCard)
                                }
                                
                                Divider()
                                    .padding(.leading, 50)
                            }
                        }
                        .background(BusTheme.backgroundCard)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Durak Ekle")
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
                isSearchFocused = true
            }
        }
    }
}
