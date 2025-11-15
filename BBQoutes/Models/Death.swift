//
//  Death.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 9.11.25.
//

import Foundation

// Model: death information associated with a character.

/// Details about a character's death, as returned by the API.
struct Death: Decodable {
    let character: String
    let image: URL
    let details: String
    let lastWords: String
}
