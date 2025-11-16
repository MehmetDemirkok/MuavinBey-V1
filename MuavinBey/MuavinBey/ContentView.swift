//
//  ContentView.swift
//  MuavinBey
//
//  Created by Mehmet Demirkök on 17.11.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var tripViewModel: TripViewModel
    
    var body: some View {
        TabView {
            TripListView(viewModel: tripViewModel)
                .tabItem {
                    Label("Seferler", systemImage: "list.bullet.rectangle")
                }
            
            StartView(viewModel: tripViewModel)
                .tabItem {
                    Label("Yeni Sefer", systemImage: "plus.circle.fill")
                }
            
            SeatAssignmentView(viewModel: tripViewModel)
                .tabItem {
                    Image(systemName: "seat.fill")
                    Text("Koltuklar")
                }
            
            TripSummaryView(viewModel: tripViewModel)
                .tabItem {
                    Label("Özet", systemImage: "chart.bar.fill")
                }
        }
        .tint(BusTheme.primaryBlue)
    }
}

#Preview {
    ContentView()
        .environmentObject(TripViewModel())
}
