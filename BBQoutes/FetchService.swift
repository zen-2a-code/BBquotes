//
//  FetchService.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 9.11.25.
//

import Foundation

// FetchService: small helper that talks to the Breaking Bad API
struct FetchService {
    // Internal errors for simple validation
    private enum FetchError: Error {
        case badResponse
    }
    
    // Base API URL
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    // target URL for fetching quotes = https://breaking-bad-api-six.vercel.app/api/quotes/random?production=show+name
    
    /// Fetch a random quote for the given show.
    /// - Parameter show: The production name used as a query (e.g., "Breaking Bad").
    func fetchQuote(from show: String) async throws -> Quote {
        // Build endpoint: /quotes/random?production=show
        let quoteURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        // Perform network request (async)
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        // Ensure HTTP 200 OK
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        // Decode JSON into a Quote
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        return quote
    }
    
    /// Fetch character details by name.
    func fetchCharacter(_ name: String) async throws -> MovieCharacter {
        // Build endpoint: /characters?name=name
        let characterURL = baseURL.appending(path: "characters")
        let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        // Perform network request (async)
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        // Ensure HTTP 200 OK
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        // Convert snake_case keys from API to camelCase properties
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Decode list and take the first match
        let characters: [MovieCharacter] = try decoder.decode([MovieCharacter].self, from: data)
        return characters[0]
    }
    
    /// Fetch death info for a character if available.
    /// - Returns: A Death if the character is found, otherwise nil.
    func fetchDeath(for character: String) async throws -> Death? {
        // Build endpoint: /deaths
        let fetchURL = baseURL.appending(path: "deaths")
        // Perform network request (async)
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        // Ensure HTTP 200 OK
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        // Convert snake_case keys from API to camelCase properties
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Decode all deaths into an array
        let deaths = try decoder.decode([Death].self, from: data)
        // Find a death matching the character name
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
        // Perform network request (async)
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        // Ensure HTTP 200 OK
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        // Convert snake_case keys from API to camelCase properties
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Decode episodes and return a random one
        let episodes: [Episode] = try decoder.decode([Episode].self, from: data)
        return episodes.randomElement()
    }
}

