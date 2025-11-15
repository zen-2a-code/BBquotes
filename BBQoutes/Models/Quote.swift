//
//  Quote.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 9.11.25.
//

// Model: a single quote and the speaker's name.

/// Quote returned by the API (or loaded from the bundle).
struct Quote: Decodable {
    let quote: String
    let character: String // Character name
}
