//
//  Episode.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 15.11.25.
//

import Foundation

// Episode model returned by the API.
struct Episode: Decodable {
    let episode: Int
    let title: String
    let image: URL
    let synopsis: String
    let writtenBy: String
    let directedBy: String
    let airDate: String
    
    // Computed helper to format season/episode from a numeric code (e.g., 305 -> S3 E5)
    var seasonEpisode: String {
        "Season \(episode / 100) Episode \(episode % 100)"
    }
}
