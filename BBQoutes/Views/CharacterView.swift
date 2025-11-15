//
//  CharacterView.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 8.11.25.
//

import SwiftUI


/**
 CharacterView: shows a character's details for a given show.
 Layout: GeometryReader -> ZStack(bg image) -> ScrollView -> VStack(content).
 Notes:
 - VStack inside ScrollView stacks many views vertically.
 - Alignment is visible when the container has width; use `.frame(maxWidth: .infinity, alignment: .leading)` or a fixed width.
 */
struct CharacterView: View {
    let character: MovieCharacter  // The movie character whose details are shown
    let show: String               // The show name used to derive background image asset
    
    var body: some View {
        // Provides container size for responsive layout
        GeometryReader { geo in
            ScrollViewReader { proxy in
                
            
            // Background image behind scrollable content
                ZStack (alignment: .top){
                    Image(show.removeCaseAndSpaces()) // Asset name derived from lowercased show name without spaces
                        .resizable()
                        .scaledToFit()
                    
                    // Vertical scrolling of character details; scroll indicators hidden below
                    ScrollView {
                        TabView {
                            
                            ForEach(character.images, id: \.self) {
                                characterImageURL in
                                // Character image (async) with a loading spinner.
                                AsyncImage(url: characterImageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(width: geo.size.width/1.2, height: geo.size.height/1.7) // Size image relative to screen.
                        .clipShape(.rect(cornerRadius: 25)) // Rounded corners.
                        .padding(.top, 60) // Spacing from top.
                        
                        // Text sections stacked vertically; left-aligned.
                        VStack (alignment:.leading){
                            // Character name
                            Text(character.name)
                                .font(.largeTitle)
                            
                            // Portrayed by info
                            Text("Potrayed by \(character.portrayedBy)")
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
                            
                            // Tap to reveal status/death info.
                            DisclosureGroup("Status (spoiler alert!)") {
                                VStack (alignment: .leading) {
                                    Text(character.status)
                                        .font(.title2)
                                    
                                    if let death = character.death {
                                        AsyncImage(url: death.image) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(.rect(cornerRadius: 15))
                                                .onAppear(){
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
                                // Give full width so `.leading` alignment is visible.
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .tint(.primary) // Tint = accent color (chevron/links). .primary adapts to light/dark.
                            
                            
                        }
                        // Tip: Narrow column? Wrap in HStack { VStack(...).frame(width: ...); Spacer() } to pin left. Or fill width + .padding(.horizontal).
                        .frame(width: geo.size.width/1.25, alignment: .leading) // Fixed readable width
                        .padding(.bottom, 50)
                        .id("characterDetails")                    }
                    // Hide scrollbar
                    .scrollIndicators(.hidden) // Scrollbar hidden so it won’t appear on the right; not due to frame
                }
            }
            
        }.ignoresSafeArea()
        
    }
}

#Preview {
    CharacterView(character: ViewModel().character, show: Constants.bbName)
}

