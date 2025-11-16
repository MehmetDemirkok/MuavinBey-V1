import SwiftUI

@main
struct MuavinApp: App {
    @StateObject private var tripViewModel = TripViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tripViewModel)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var tripViewModel: TripViewModel
    
    var body: some View {
        TabView {
            StartView(viewModel: tripViewModel)
                .tabItem {
                    Label("Yeni Sefer", systemImage: "plus.circle")
                }
            
            StopManagementView(viewModel: tripViewModel)
                .tabItem {
                    Label("Duraklar", systemImage: "mappin.circle")
                }
                .disabled(tripViewModel.currentTrip == nil)
            
            SeatAssignmentView(viewModel: tripViewModel)
                .tabItem {
                    Label("Koltuklar", systemImage: "seat.fill")
                }
                .disabled(tripViewModel.currentTrip == nil)
            
            TripSummaryView(viewModel: tripViewModel)
                .tabItem {
                    Label("Özet", systemImage: "list.bullet")
                }
                .disabled(tripViewModel.currentTrip == nil)
        }
    }
}

