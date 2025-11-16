//
//  CharacterView.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 8.11.25.
//

import SwiftUI

// CharacterView: shows details for a character with images and metadata.
struct CharacterView: View {
    // Data to display
    let character: MovieCharacter  
    // Used to pick themed background image
    let show: String               
    
    var body: some View {
        // Get screen size for responsive layout
        GeometryReader { geo in
            ScrollViewReader { proxy in
                // Background image with scrollable content on top
                ZStack (alignment: .top){
                    Image(show.removeCaseAndSpaces()) // Background derived from show name (lowercased, no spaces)
                        .resizable()
                        .scaledToFit()
                    
                    // Vertical scroll for long content
                    ScrollView {
                        // Swipe through character images
                        TabView {
                            ForEach(character.images, id: \.self) { characterImageURL in
                                AsyncImage(url: characterImageURL) { image in // Load remote image
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .tabViewStyle(.page) // Page dots + swipe
                        .frame(width: geo.size.width/1.2, height: geo.size.height/1.7) // Size image relative to screen.
                        .clipShape(.rect(cornerRadius: 25)) // Rounded corners.
                        .padding(.top, 60) // Spacing from top.
                        
                        // Text sections
                        VStack (alignment:.leading){
                            // Character name
                            Text(character.name)
                                .font(.largeTitle)
                            
                            // Portrayed by info
                            Text("Portrayed by \(character.portrayedBy)")
                                .font(.subheadline)
                            
                            // Section break
                            Divider()
                            
                            // Character info heading
                            Text("\(character.name) Character info")
                                .font(.title2)
                            
                            // Birthday info
                            Text("Born: \(character.birthday)")
                            
                            // Section break
                            Divider()
                            
                            // Occupations list
                            Text("Occupations: ")
                                .font(.title2)
                            
                            // Occupations list
                            ForEach(character.occupations, id: \.self) { occupation in
                                Text(("•\(occupation)")) // Bullet point styling for occupation
                                    .font(.subheadline)
                            }
                            
                            // Section break
                            Divider()
                            
                            // Nicknames (or None)
                            Text("Nicknames: ")
                            if character.aliases.count > 0 {
                                ForEach(character.aliases, id: \.self) { alias in
                                    Text(("•\(alias)")) // Bullet point styling for nickname
                                        .font(.subheadline)
                                }
                            } else {
                                Text("None")
                                    .font(.subheadline)
                            }
                            
                            // Section break
                            Divider()
                            
                            // Tap to reveal status and death info
                            DisclosureGroup("Status (spoiler alert!)") {
                                VStack (alignment: .leading) {
                                    Text(character.status)
                                        .font(.title2)
                                    
                                    if let death = character.death {
                                        AsyncImage(url: death.image) { image in // Load death image
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(.rect(cornerRadius: 15))
                                                .onAppear { // Auto-scroll to details when image appears
                                                    withAnimation {
                                                        proxy.scrollTo("characterDetails", anchor: .bottom)
                                                    }
                                                }
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        
                                        Text("How: \(death.details)")
                                            .padding(.bottom, 7)
                                        Text("Last words: \"\(death.lastWords)\"")
                                    }
                                }
                                // Give full width so .leading alignment is visible.
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .tint(.primary) // Tint = accent color (chevron/links). .primary adapts to light/dark.
                        }
                        // Tip: Narrow column? Wrap in HStack { VStack(...).frame(width: ...); Spacer() } to pin left. Or fill width + .padding(.horizontal).
                        .frame(width: geo.size.width/1.25, alignment: .leading) // Fixed readable width
                        .padding(.bottom, 50)
                        .id("characterDetails")
                    }
                    .scrollIndicators(.hidden) // Hide scrollbar
                }
            }
        }.ignoresSafeArea()
    }
}

// Preview with sample data
#Preview {
    CharacterView(character: ViewModel().character, show: Constants.bbName)
}
