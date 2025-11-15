//
//  FetchService.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 9.11.25.
//

import Foundation

// Service layer: handles all network requests. Keeps ViewModel simple and testable.

// FetchService: builds URLs, calls the API, and decodes responses.
struct FetchService {
    // Internal errors we can throw when responses are invalid.
    private enum FetchError: Error {
        case badResponse
    }
    
    // Base API URL; we append paths and query items to build endpoints.
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    // target URL for fetching quotes = https://breaking-bad-api-six.vercel.app/api/quotes/random?production=show+name
    
    /// Fetch a random quote for the given show.
    /// - Parameter show: The production name used as a query (e.g., "Breaking Bad").
    func fetchQuote(from show: String) async throws -> Quote {
        // Build the endpoint URL
        let quoteURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        // Perform the request (data + response).
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // Validate HTTP status code.
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        // Decode the JSON into a Quote.
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        
        // Return the decoded quote.
        return quote
    }
    
    /// Fetch character details by name.
    func fetchCharacter(_ name: String) async throws -> MovieCharacter {
        let characterURL = baseURL.appending(path: "characters")
        let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        // Use a decoder that converts snake_case JSON keys to camelCase Swift properties.
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // API returns an array; decode it and take the first match.
        let characters: [MovieCharacter] = try decoder.decode([MovieCharacter].self, from: data)
        
        // Return the first character.
        return characters[0]
    }
    
    /// Fetch death info for a character if available.
    /// - Returns: A Death if the character is found, otherwise nil.
    func fetchDeath(for character: String) async throws -> Death? {
        // Optional because the character may still be alive.
        let fetchURL = baseURL.appending(path: "deaths")
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Decode all deaths returned by the API.
        let deaths = try decoder.decode([Death].self, from: data)
        
        // Find a matching entry for the given character.
        for death in deaths {
            if death.character == character {
                return death
            }
        }
        return nil
        
    }
}
