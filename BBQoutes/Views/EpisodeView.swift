//
//  EpisodeView.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 15.11.25.
//

import SwiftUI

// EpisodeView: shows details for a single episode.
struct EpisodeView: View {
    // Data to display
    let episode: Episode
    
    
    var body: some View {
        // Text + image stacked vertically
        VStack (alignment: .leading) {
            // Title
            Text(episode.title)
                .font(.largeTitle)
            
            // Season/Episode formatted
            Text(episode.seasonEpisode)
                .font(.title2)
            
            AsyncImage (url: episode.image) { image in // Remote image
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 15))
            } placeholder: {
                ProgressView()
            }
            
            // Summary
            Text(episode.synopsis)
                .font(.title3)
                .minimumScaleFactor(0.5)
                .padding(.bottom)
            
            // Credits and air date
            Text("Written By: \(episode.writtenBy)")
            Text("Directed By: \(episode.directedBy)")
            Text("Aired: \(episode.airDate)")
        }
        // Card styling
        .padding()
        .foregroundStyle(.white)
        .background(.black.opacity(0.6))
        .clipShape(.rect(cornerRadius: 25))
        .padding(.horizontal)
    }
}

// Preview with sample data
#Preview {
    EpisodeView(episode: ViewModel().episode)
}
