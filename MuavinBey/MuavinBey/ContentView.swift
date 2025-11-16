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
        }
        .tint(BusTheme.primaryBlue)
    }
}

#Preview {
    ContentView()
        .environmentObject(TripViewModel())
}
