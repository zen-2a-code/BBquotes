//
//  ContentView.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 8.11.25.
//

import SwiftUI

struct ContentView: View {
        var body: some View {
            TabView {
                Tab("Breaking Bad", systemImage: "tortoise") {
                    QuoteView(show: "Breaking Bad")
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                }
                
                Tab("Better Call Saul Bad", systemImage: "briefcase") {
                    QuoteView(show: "Better Call Saul")
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                }
            }
            .preferredColorScheme(.dark)
            
        }
    }

    #Preview {
        ContentView()
    }
