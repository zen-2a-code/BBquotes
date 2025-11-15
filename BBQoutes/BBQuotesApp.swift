//
//  BBQoutesApp.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 8.11.25.
//

import SwiftUI
// App entry: shows ContentView in a window.

// SwiftUI app entry point.
@main
struct BBQoutesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/**
 Roadmap (v2)
  - ✅ Add El Camino tab
  - ✅ Use all character images in CharacterView
  - ✅ Auto-scroll to bottom after status is shown
  - ✅ Fetch episode data
  - ✅  Shorten image/color name lookups
  - ✅  Create static constants for show names
 */
