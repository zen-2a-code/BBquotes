//
//  FetchView.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 8.11.25.
//

import SwiftUI

// FetchView shows a background image for a TV show and lets the user fetch a random quote or episode.
struct FetchView: View {
    // View model that handles network calls and state for the UI
    let viewModel = ViewModel()
    // The current show name (e.g., "Breaking Bad") used for theming and API requests
    let show: String
    // Controls if the character details sheet is visible
    @State var showCharacterInfo = false
    
    // Main view layout
    var body: some View {
        // Gives access to the screen size (geo.size)
        GeometryReader { geo in
            // Background image behind the main content
            ZStack {
                // Use the show name to pick a matching background asset
                Image(show.removeCaseAndSpaces())
                    .resizable()
                    // This image intentionally exceeds the screen to achieve the visual look.
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)

                // Vertical layout for content and actions
                VStack {
                    // Main content area that changes based on loading state
                    VStack{
                        // Push content down a bit from the top
                        Spacer(minLength: 60)
                        
                        // Show different views depending on the current loading status
                        switch viewModel.status {
                        case .notStarted: // Nothing yet - wait for first fetch
                            EmptyView()
                        case .successQuote: // Show fetched quote
                            QuoteView(viewModel: viewModel, showCharacterInfo: $showCharacterInfo, geoSize: geo.size)
                            
                        case .fetching: // Loading indicator while fetching
                            ProgressView()

                        case .successEpisode: // Show fetched episode
                            EpisodeView(episode: viewModel.episode)
                        case .failed(error: let error): // Show error message
                            Text(error.localizedDescription)
                        }
                        // Add breathing room below the content
                        Spacer(minLength: 20)
                    }
                    
                    // Action buttons to fetch a quote or an episode
                    HStack {
                        Button {
                            Task {
                                // Fetch a random quote for the current show
                                await viewModel.getQuoteData(for: show)
                            }
                        } label: {
                            // Button styling matches the current show's theme
                            Text("Get Random Quote")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 7))
                                .contentShape(.rect(cornerRadius: 7))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                        
                        Spacer()
                        
                        Button {
                            Task {
                                // Fetch a random episode for the current show
                                await viewModel.getEpisode(for: show)
                            }
                        } label: {
                            // Button styling matches the current show's theme
                            Text("Get Random Episode")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 7))
                                .contentShape(.rect(cornerRadius: 7))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                    }
                    // Keep buttons away from screen edges
                    .padding(.horizontal, 30)
                    // Leave space for the tab bar at the bottom
                    Spacer(minLength: 95)
                }
                // Keep the content constrained to the screen size
                .frame(width: geo.size.width, height: geo.size.height)
            }
            // Run once when the view appears: prefetch a quote
            .task {
                await viewModel.getQuoteData(for: show)
            }
            // Make the container match the screen size
            .frame(width: geo.size.width, height: geo.size.height)
        }
        // Let the background extend under system bars
        .ignoresSafeArea()
        // Ensure the tab bar stays visible over the background
        .toolbarBackgroundVisibility(.visible, for: .tabBar) // Keep tab bar visible. Placing it here avoids repeating in each tab.
        // Present character details when requested
        .sheet(isPresented: $showCharacterInfo) {
            // Pass the selected character and current show to the sheet
            CharacterView(character: viewModel.character, show: show)
        }
    }
}

// Preview with a default show and dark mode
#Preview {
    FetchView(show: Constants.bbName)
        .preferredColorScheme(.dark)
}
