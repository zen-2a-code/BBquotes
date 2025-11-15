//
//  MovieCharacter.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 9.11.25.
//

import Foundation
// Model: describes a character returned by the API.

/// MovieCharacter represents one character with metadata and images.
struct MovieCharacter: Decodable {
    let name: String
    let birthday: String
    let occupations: [String]
    let images: [URL]
    let aliases: [String]
    let status: String
    let portrayedBy: String
    var death: Death? // nil initially

    // Explicit keys for manual decoding in init(from:).
    enum CodingKeys: CodingKey {
        case name
        case birthday
        case occupations
        case images
        case aliases
        case status
        case portrayedBy
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.birthday = try container.decode(String.self, forKey: .birthday)
        self.occupations = try container.decode([String].self, forKey: .occupations)
        self.images = try container.decode([URL].self, forKey: .images)
        self.aliases = try container.decode([String].self, forKey: .aliases)
        self.status = try container.decode(String.self, forKey: .status)
        self.portrayedBy = try container.decode(String.self, forKey: .portrayedBy)
        
        // Separate decoder to use snake_case conversion for the sample death JSON.
        let jSONDecoder = JSONDecoder()
        jSONDecoder.keyDecodingStrategy = .convertFromSnakeCase

        // Load a sample death from the bundle to prefill data in the demo.
        let deathData = try Data(contentsOf: Bundle.main.url(forResource: "sampledeath", withExtension: "json")!)
        self.death = try jSONDecoder.decode(Death.self, from: deathData)
    }
}

