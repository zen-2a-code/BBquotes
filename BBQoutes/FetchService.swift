//
//  FetchService.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 9.11.25.
//

import Foundation

// Service: builds URLs, calls the API, decodes responses.
struct FetchService {
    private enum FetchError: Error {
        case badResponse
    }
    
    // Base URL (e.g., .../api)
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    // target URL for fetching quotes = https://breaking-bad-api-six.vercel.app/api/quotes/random?production=show+name
    
    /// Fetch a random quote for the given show.
    /// - Parameter show: The production name used as a query (e.g., "Breaking Bad").
    func fetchQuote(from show: String) async throws -> Quote {
        // Build endpoint: /quotes/random?production=show
        let quoteURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        // Request data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        // Validate status code
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        // Decode Quote
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        return quote
    }
    
    /// Fetch character details by name.
    func fetchCharacter(_ name: String) async throws -> MovieCharacter {
        // Build endpoint: /characters?name=name
        let characterURL = baseURL.appending(path: "characters")
        let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        // Request data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        // Validate status code
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        // snake_case -> camelCase
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Decode array, take first
        let characters: [MovieCharacter] = try decoder.decode([MovieCharacter].self, from: data)
        return characters[0]
    }
    
    /// Fetch death info for a character if available.
    /// - Returns: A Death if the character is found, otherwise nil.
    func fetchDeath(for character: String) async throws -> Death? {
        // Build endpoint: /deaths
        let fetchURL = baseURL.appending(path: "deaths")
        // Request data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        // Validate status code
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        // snake_case -> camelCase
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Decode all deaths
        let deaths = try decoder.decode([Death].self, from: data)
        // Find match
        for death in deaths {
            if death.character == character {
                return death
            }
        }
        return nil
    }
    
    func fetchEpisode(_ show: String) async throws -> Episode? {
        // Build endpoint: /characters?name=name
        let episodeURL = baseURL.appending(path: "episodes")
        let fetchURL = episodeURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        // Request data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        // Validate status code
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        // snake_case -> camelCase
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Decode array, take first
        let episodes: [Episode] = try decoder.decode([Episode].self, from: data)
        return episodes.randomElement()
    }
}
