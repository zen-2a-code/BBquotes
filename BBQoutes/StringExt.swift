//
//  StringExt.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 15.11.25.
//

// String helpers: tiny, focused utilities used across views.
// Good practice: keep extensions small, predictable, and app-specific.
// If a helper is domain-specific or widely reused, consider a named type or utility.

import Foundation

// Prefer verbs that describe transformation; do not mutate self.
extension String {
    /// Remove all spaces (e.g., "El Camino" -> "ElCamino").
    func removeSpaces() -> String{
        self.replacingOccurrences(of: " ", with: "")
    }
    
    /// Lowercase and remove spaces (e.g., "El Camino" -> "elcamino").
    func removeCaseAndSpaces() -> String {
        self.removeSpaces().lowercased()
    }
}
