//
//  Constants.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 15.11.25.
//

// Constants: app-wide names/keys used in multiple places.
// Why: avoid magic strings and typos; change in one place.
// Tip: keep only broadly reused values here (don’t dump everything).

enum Constants { // Namespace for static constants (avoids global vars)
    static let bbName = "Breaking Bad"   // Tab, assets, API query
    static let bcsName = "Better Call Saul" // Tab, assets, API query
    static let ecName = "El Camino"        // Tab, assets, API query
}
