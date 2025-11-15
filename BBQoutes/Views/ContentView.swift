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
        var body: some View {
            TabView {
                // Tab: Breaking Bad — shows quotes for this production.
                Tab("Breaking Bad", systemImage: "tortoise") {
                    QuoteView(show: "Breaking Bad")
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        // Keep the tab bar visible over dark backgrounds.
                }
                
                // Tab: Better Call Saul — shows quotes for this production.
                Tab("Better Call Saul", systemImage: "briefcase") {
                    QuoteView(show: "Better Call Saul")
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        // Keep the tab bar visible over dark backgrounds.
                }
            }
            // Force dark mode to match the show's aesthetic.
            .preferredColorScheme(.dark)
            
        }
    }

    #Preview {
        ContentView()
    }

