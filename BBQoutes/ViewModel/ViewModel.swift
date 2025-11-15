//
//  ViewModel.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 9.11.25.
//

// MVVM:
// - Model: data types (Quote, Death, MovieCharacter)
// - View: SwiftUI screens
// - ViewModel: fetches data, exposes observable state

import Foundation

// Tip: mark members private if no other type needs them.

// @Observable: make properties observable
@Observable
// @MainActor: update UI on main thread
@MainActor
// Class: we need reference semantics and an initializer to set up properties (quote, fetcher, status).
class ViewModel {
    /// Network/loading states for the ViewModel. Used to drive UI feedback.
    enum FetchStatus {
        case notStarted
        case fetching
        case successQuote
        case successEpisode
        // we can attach data to the enum cases (name: Type)
        case failed(error: Error)
    }
    
    // private(set): views can read status, but only the ViewModel can change it.
    private(set) var status: FetchStatus = .notStarted
    
    // Service responsible for network calls. Kept private to encapsulate fetching details.
    private let fetcher = FetchService()
    
    // Current quote shown on screen.
    var quote: Quote
    // Character associated with the quote.
    var character: MovieCharacter
    var episode: Episode
    
    /// Load sample data from bundled JSON for initial UI.
    /// Demo-only: force-unwrap bundled sample JSON (safe in controlled samples).
    init() {
        // Decode JSON using snake_case -> camelCase.
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        // Load sample quote JSON.
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)

        // Decode the Data into our Quote type.
        quote = try! decoder.decode(Quote.self, from: quoteData)

        // Load sample character JSON.
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(MovieCharacter.self, from: characterData)
        
        let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        episode = try! decoder.decode(Episode.self, from: episodeData)
    }
    
    /// Fetch random quote + character + optional death for the show.
    func getQuoteData(for show: String) async {
        status = .fetching
        do {
            quote = try await fetcher.fetchQuote(from: show)
            character = try await fetcher.fetchCharacter(quote.character)
            character.death = try await fetcher.fetchDeath(for: character.name)
            
            status = .successQuote
        } catch {
            status = .failed(error: error)
        }
        
    }
    
    func getEpisode(for show: String) async {
        status = .fetching
        
        do {
            if let unwrappedEpisode = try await fetcher.fetchEpisode(show) {
                episode = unwrappedEpisode
            }
            
            status = .successEpisode
        } catch {
            status = .failed(error: error)
        }
    }
    
}
