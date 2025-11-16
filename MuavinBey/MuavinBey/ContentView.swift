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
            StartView(viewModel: tripViewModel)
                .tabItem {
                    Label("Yeni Sefer", systemImage: "plus.circle.fill")
                }
            
            StopManagementView(viewModel: tripViewModel)
                .tabItem {
                    Label("Duraklar", systemImage: "mappin.circle.fill")
                }
            
            SeatAssignmentView(viewModel: tripViewModel)
                .tabItem {
                    Label("Koltuklar", systemImage: "seat.fill")
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
