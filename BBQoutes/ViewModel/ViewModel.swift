//
//  ViewModel.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 9.11.25.
//

// Model - This is the data layer. It represents the app's data logic and rules. struct/classes like Quote, Death,MovieCharacter
// View = what the user sees and the code behind.

// The only diffrance between MVC and MVVM is that the controller in MVC and the ViewModel in MVVM.
// Similarties between MVC and MVVM:
// - Both Controller in MVC and ViewModel in MVVM are the middle layer between the view and the model it is used as Manipulate data layer.

// Diffrances:
// - View model expose itself to the view - it attach itself to the View

import Foundation

// ViewModel is observable to the view. The view treads ViewModel propreties as their on.
// When our viewmodel is expodes we need to consider access control.
// how private do we make our properties and fucntons.
// The question to ask whenever we want to dicide if we want something to be set as private is. Does anyone outside this [file] need access to this property/method


// every single property will act as state property on our Views (triger refresh of UI)
@Observable
// The left lene (the fasters lene) has a name - MainActor - The UI always run on Main Actor. as viewModel is so closely connect to the UI (views) it should be also running on the fastest lene (to
// always be in sync with Views)
@MainActor
// we selected our ViewModel to be a class is because we are required to select initial value to all properties - like quote, fetcher, status (before the class declaraion is finish)
class ViewModel {
    enum FetchStatus {
        case notStarted
        case fetching
        case success
        // we can attach data to the enum cases (name: Type)
        case failed(error: Error)
    }
    
    private(set) var status: FetchStatus = .notStarted
    
    private let fetcher = FetchService()
    
    var quote: Quote
    var character: MovieCharacter
    
    // special function that runs automatically as soon as we intialize a new instance of new Model
    init() {
        // 1) Create a JSON decoder that will turn raw JSON into our Swift types (Quote, M ovieCharacter).
        let decoder = JSONDecoder()
        // Tell the decoder how to map JSON keys to Swift property names.
        // Example: "first_name" in JSON becomes "firstName" in Swift.
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        // About try, try?, try! and the two different "!" you see below:
        // - try: says "this can throw an error" and you must handle it (usually with do/catch).
        // - try?: turns an error into nil (optional) instead of throwing.
        // - try!: "force-try" — if an error happens, the app will crash. Only use when you are 100% sure it can't fail.
        // - ! at the END of an expression (e.g. url(... )!): "force-unwrap" an Optional. If the value is nil, the app will crash.
        // In sample/demo apps it’s common to use try! and ! when reading bundled files we control.
        // In production code, prefer safe handling (guard/do-catch) so the app doesn’t crash.

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
