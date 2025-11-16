//
//  Quote.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 9.11.25.
//

// Model: a single quote and the speaker's name.

// Quote model returned by the API.
struct Quote: Decodable {
    let quote: String
    let character: String // Character name
}
