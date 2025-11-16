//
//  ContentView.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 8.11.25.
//

import SwiftUI

// Root view: Tab bar with three shows.
struct ContentView: View {
    // Each tab embeds FetchView for a different show
    var body: some View {
        // Tip: .toolbarBackgroundVisibility(.visible, for: .tabBar) keeps the tab bar readable over images.
        TabView {
            // Tab: Breaking Bad — shows quotes for this production.
            Tab(Constants.bbName, systemImage: "tortoise") {
                FetchView(show: Constants.bbName)
            }
            
            // Tab: Better Call Saul — shows quotes for this production.
            Tab(Constants.bcsName, systemImage: "briefcase") {
                FetchView(show: Constants.bcsName)
            }
            
            Tab(Constants.ecName, systemImage: "car") {
                FetchView(show: Constants.ecName)
            }
        }
        // Force dark mode for consistent look
        // Force dark mode to match the show's aesthetic.
        .preferredColorScheme(.dark)
        
    }
}

#Preview {
    ContentView()
}
