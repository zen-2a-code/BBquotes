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

// @Observable: auto-tracks changes to properties so SwiftUI views update automatically when values change
@Observable
// @MainActor: runs this type on the main thread so UI updates are safe (avoids crashes/glitches from background threads)

// Class (not struct): ViewModels hold shared, mutable state observed by many views.
// Structs can be single instances too, but they are value types (copies). Classes are reference types (one shared object).
// We choose class so all views observe the same changing state, which fits @Observable/@MainActor and MVVM best practice.

/**
 • Struct = value type (copy on write): When you pass a struct around, each place gets its own copy. Changing it in one place doesn’t automatically change it everywhere else.
 • Class = reference type (shared): When you pass a class around, everyone refers to the same instance. Changing it in one place is seen by everyone.
 */
class ViewModel {
    // Loading states that drive the UI
    /// Network/loading states for the ViewModel. Used to drive UI feedback.
    enum FetchStatus {
        case notStarted
        case fetching
        case successQuote
        case successEpisode
        // we can attach data to the enum cases (name: Type)
        case failed(error: Error)
    }
    
    // Current loading state (readable by views, mutated here)
    // private(set): views can read status, but only the ViewModel can change it.
    private(set) var status: FetchStatus = .notStarted
    
    // Service responsible for network calls. Kept private to encapsulate fetching details.
    private let fetcher = FetchService()
    
    var quote: Quote
    var character: MovieCharacter
    var episode: Episode
    
    /// Load sample data from bundled JSON for initial UI.
    /// Demo-only: force-unwrap bundled sample JSON (safe in controlled samples).
    init() {
        // Demo setup: preload sample JSON so the UI has data before the first fetch
        // Decode JSON using snake_case -> camelCase.
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        // Load sample quote JSON.
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)

        // Decode the Data into our Quote type.
        quote = try! decoder.decode(Quote.self, from: quoteData)

        // Load sample character JSON.
        let characterData  = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(MovieCharacter.self, from: characterData)
        
        let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        episode = try! decoder.decode(Episode.self, from: episodeData)
    }
    
    /// Fetch random quote + character + optional death for the show.
    func getQuoteData(for show: String) async {
        // 1) Enter loading state
        status = .fetching
        do {
            // 2) Fetch quote for the selected show
            quote = try await fetcher.fetchQuote(from: show)
            // 3) Fetch full character details
            character = try await fetcher.fetchCharacter(quote.character)
            // 4) Optionally load death info (may be nil)
            character.death = try await fetcher.fetchDeath(for: character.name)
            
            // 5) Show quote UI
            status = .successQuote
        } catch {
            // If any step fails, show an error
            status = .failed(error: error)
        }
        
    }
    
    func getEpisode(for show: String) async {
        // 1) Enter loading state
        status = .fetching
        
        do {
            // 2) Fetch a random episode for the show
            if let unwrappedEpisode = try await fetcher.fetchEpisode(show) {
                // 3) Update current episode
                episode = unwrappedEpisode
            }
            
            // 4) Show episode UI
            status = .successEpisode
        } catch {
            // If the request fails, show an error
            status = .failed(error: error)
        }
    }
    
}

