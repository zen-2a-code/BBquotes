//
//  QuoteView.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 15.11.25.
//

import SwiftUI

// QuoteView: shows a quote bubble and a tappable character card.
struct QuoteView: View {
    // Source of quote + character data
    let viewModel : ViewModel
    // Parent controls the character sheet
    @Binding var showCharacterInfo: Bool
    // Parent passes container size
    let geoSize: CGSize
    
    
    var body: some View {
        // Quote bubble
        Text("\"\(viewModel.quote.quote ) \"")
            .minimumScaleFactor(0.5)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding()
            .background(.black.opacity(0.5)) // Semi-transparent bubble
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding(.horizontal)
        
        // Character card with image and name
        ZStack (alignment: .bottom) {
            
            AsyncImage(url: viewModel.character.images.randomElement()) { image in // Load a random character image
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: geoSize.width/1.1, height: geoSize.height/1.8) // Size relative to screen
            .clipShape(.rect(cornerRadius: 50))
            
            Text(viewModel.quote.character) // Name overlay
                .foregroundStyle(.white)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            
        }
        // Set container size before clipping.
        .frame(width: geoSize.width/1.1, height: geoSize.height/1.8) // Size relative to screen
        .clipShape(.rect(cornerRadius: 50))
        .onTapGesture { // Tap to show character details
            showCharacterInfo.toggle()
        }
        
    }
}

// Preview with sample ViewModel
#Preview {
    @Previewable @State var showCharacterInfo = false
    QuoteView(viewModel: ViewModel(), showCharacterInfo: $showCharacterInfo, geoSize: CGSize(width: 393, height: 852))
}

