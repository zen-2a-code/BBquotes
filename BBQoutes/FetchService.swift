//
//  FetchService.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 9.11.25.
//

import Foundation


// Many devs would have called this FetchController because this is the thing that contorlls all the fetching.
struct FetchService {
    private enum FetchError: Error {
        case badResponse
    }
    
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    // target URL for fetching quotes = https://breaking-bad-api-six.vercel.app/api/quotes/random?production=show+name
    
    func fetchQuote(from show: String) async throws -> Quote {
        // Build fetch URL
        let quoteURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        // Fetch data from url
        // This is a Tuple -> (Food, Drink) it is not limited to, it might be more than 2
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // Handle response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { // here it is imporant to note that we can chain guard checks, if the response is actually of that type
            // then we check that the response is with this status code. The as is actually casting, and if the casting fails it results in nil - so it enterer the else instead of desclaring the response variable.
            throw FetchError.badResponse
        }
        
        // If data okay - decode data and put in Quote model
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        
        // Return the quote
        return quote
    }
    
    func fetchCharacter(_ name: String) async throws -> MovieCharacter {
        let characterURL = baseURL.appending(path: "characters")
        let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        // we need to create a seprate decoder and not to use the default JSON Decoder as we have two worded variables both in our Model and in the JSON data itself. and we need to implement decoding stratagy.
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // we need to decode with an array [MovieCharacters] because of how the API returns the JSON it currenly returns an array of objects (key-value pairs)
        let characters: [MovieCharacter] = try decoder.decode([MovieCharacter].self, from: data)
        
        // We return the first item from the Array as we have an array instead of just one character property
        return characters[0]
    }
    
    // we return an optional Death object because the character might be still alive. So if that is the case we return nil
    func fetchDeath(for character: String) async throws -> Death? {
        let fetchURL = baseURL.appending(path: "deaths")
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // in this collection we indeed have more than one death - we have all characters deaths data.
        let deaths = try decoder.decode([Death].self, from: data)
        
        // in swiftUI we have a view called forEach it help us loop though some code and build views more than once. In swift we have loop - for
        
        // we want to return only the death data for the character if he is actually dead, otherwise we want to return  nil
        
        for death in deaths {
            if death.character == character {
                return death
            }
        }
        return nil
        
    }
}
