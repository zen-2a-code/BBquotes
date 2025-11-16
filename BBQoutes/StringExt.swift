//
//  StringExt.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 15.11.25.
//

// Small String helpers used in multiple views.

import Foundation

// Prefer verbs; return new strings (do not mutate self).
extension String {
    // Remove spaces: "El Camino" -> "ElCamino"
    /// Remove all spaces (e.g., "El Camino" -> "ElCamino").
    func removeSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    // Lowercase + remove spaces: "El Camino" -> "elcamino"
    /// Lowercase and remove spaces (e.g., "El Camino" -> "elcamino").
    func removeCaseAndSpaces() -> String {
        self.removeSpaces().lowercased()
    }
}
