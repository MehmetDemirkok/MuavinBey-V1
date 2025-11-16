import SwiftUI

struct StopManagementView: View {
    @ObservedObject var viewModel: TripViewModel
    @State private var newStopName = ""
    @State private var showingAddStop = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let trip = viewModel.currentTrip {
                    if trip.stops.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "mappin.circle")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("Henüz durak eklenmedi")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Durak eklemek için aşağıdaki butona basın")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(trip.stops) { stop in
                                HStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(.blue)
                                    Text(stop.name)
                                        .font(.body)
                                }
                            }
                            .onDelete(perform: deleteStops)
                            .onMove(perform: moveStops)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: { showingAddStop = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Durak Ekle")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Durak Yönetimi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddStop) {
                AddStopSheet(viewModel: viewModel, stopName: $newStopName)
            }
        }
    }
    
    private func deleteStops(at offsets: IndexSet) {
        guard let trip = viewModel.currentTrip else { return }
        for index in offsets {
            viewModel.deleteStop(trip.stops[index])
        }
    }
    
    private func moveStops(from source: IndexSet, to destination: Int) {
        viewModel.moveStop(from: source, to: destination)
    }
}

struct AddStopSheet: View {
    @ObservedObject var viewModel: TripViewModel
    @Binding var stopName: String
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Durak Adı")) {
                    TextField("Örn: Esenler Otogar", text: $stopName)
                        .focused($isTextFieldFocused)
                }
            }
            .navigationTitle("Yeni Durak")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        if !stopName.isEmpty {
                            viewModel.addStop(name: stopName)
                            stopName = ""
                            dismiss()
                        }
                    }
                    .disabled(stopName.isEmpty)
                }
            }
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }
}

