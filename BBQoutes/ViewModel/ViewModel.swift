//
//  ViewModel.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 9.11.25.
//

// MVVM quick guide (junior-friendly):
// - Model: data structures and rules (e.g., Quote, Death, MovieCharacter).
// - View: what the user sees (SwiftUI views).
// - ViewModel: the middle layer; fetches and prepares data for the View.
//
// Differences vs MVC:
// - In MVVM, the ViewModel exposes observable state to the View.
// - The View binds to that state and updates automatically when it changes.

import Foundation

// The ViewModel exposes observable state to the View.
// Access control tip: mark members private if no one outside this type needs them.
// Ask: “Does any other type need this?” If not, make it private or private(set).

// @Observable: makes stored properties observable by SwiftUI.
// When a property changes, views that depend on it re-render.
@Observable
// @MainActor: run on the main thread so UI state stays in sync with views.
@MainActor
// Class: we need reference semantics and an initializer to set up properties (quote, fetcher, status).
class ViewModel {
    /// Network/loading states for the ViewModel. Used to drive UI feedback.
    enum FetchStatus {
        case notStarted
        case fetching
        case success
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
    
    /// Load sample data from bundled JSON for initial UI.
    /// Junior tip: try! and force-unwraps are okay for controlled demo data; avoid them in production.
    init() {
        // About try/try?/try! and "!" (force unwrap):
        // - try: can throw; handle with do/catch.
        // - try?: converts errors to nil.
        // - try!: crash on error (only for guaranteed data).
        // - !: force-unwrap an Optional (crashes if nil).
        
        // 1) Create a JSON decoder that will turn raw JSON into our Swift types (Quote, M ovieCharacter).
        let decoder = JSONDecoder()
        // Tell the decoder how to map JSON keys to Swift property names.
        // Example: "first_name" in JSON becomes "firstName" in Swift.
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        // Load the JSON file from the app bundle as raw Data.
        // Bundle.main.url(...) returns an Optional URL because the file might not exist.
        // We use "!" to force-unwrap the URL because we know the file is included in the app bundle.
        // Data(contentsOf:) can throw if reading the file fails, so we use "try!" to force-try here as well.
        // If either the URL is missing or reading fails, the app will crash — which is acceptable for a controlled sample.
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)

        // Decode the Data into our Quote type.
        // decoder.decode(...) can throw if the JSON doesn’t match the structure of Quote.
        // Again, we use "try!" because this sample guarantees the JSON matches the model.
        
        quote = try! decoder.decode(Quote.self, from: quoteData)

        // Repeat the same steps for the character JSON.
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(MovieCharacter.self, from: characterData)
    }
    
    /// Fetch a random quote, its character, and optional death info for the given show.
    /// async/await: suspend while network calls run; resume when each finishes.
    /// Errors are captured and mapped to status so the UI can react.
    func getData(for show: String) async {
        status = .fetching
        do {
            quote = try await fetcher.fetchQuote(from: show)
            character = try await fetcher.fetchCharacter(quote.character)
            character.death = try await fetcher.fetchDeath(for: character.name)
            
            status = .success
        } catch {
            status = .failed(error: error)
        }
        
    }
    
}
