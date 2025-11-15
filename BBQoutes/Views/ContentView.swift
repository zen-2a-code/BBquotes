//
//  ContentView.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 8.11.25.
//

import SwiftUI

// Root view: hosts two tabs (Breaking Bad, Better Call Saul).

/// ContentView sets up the tab interface and injects QuoteView per tab.
struct ContentView: View {
    // Tabs reuse QuoteView(show:). Pass a different show string + assets to add a new tab.
    var body: some View {
        TabView {
            // Tip: .toolbarBackgroundVisibility(.visible, for: .tabBar) keeps the tab bar readable over images.
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
        // Force dark mode to match the show's aesthetic.
        .preferredColorScheme(.dark)
        
    }
}

#Preview {
    ContentView()
}
