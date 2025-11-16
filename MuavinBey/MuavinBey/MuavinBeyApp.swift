//
//  MuavinBeyApp.swift
//  MuavinBey
//
//  Created by Mehmet Demirkök on 17.11.2025.
//

import SwiftUI

@main
struct MuavinBeyApp: App {
    @StateObject private var tripViewModel = TripViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tripViewModel)
        }
    }
}
