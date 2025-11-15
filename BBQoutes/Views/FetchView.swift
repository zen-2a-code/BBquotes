//
//  FetchView.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 8.11.25.
//

import SwiftUI

struct FetchView: View {
    let viewModel = ViewModel()
    let show: String
    @State var showCharacterInfo = false
    
    var body: some View {
        // give us an access to our screen size
        GeometryReader { geo in
            ZStack {
                // Background image named from show (e.g., "El Camino" -> "elcamino"). It’s oversized for the look.
                Image(show.removeCaseAndSpaces())
                    .resizable()
                    // This image intentionally exceeds the screen to achieve the visual look.
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)

                // Constrain content to screen size so text wraps and layout stays stable.
                VStack {
                    VStack{
                        Spacer(minLength: 60)
                        
                        switch viewModel.status {
                        case .notStarted:
                            EmptyView()
                            
                        case .fetching:
                            ProgressView()
                            
                        case .successQuote:
                            // Quote bubble
                            Text("\"\(viewModel.quote.quote ) \"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .padding(.horizontal)
                            
                            // Character card
                            ZStack (alignment: .bottom) {
                                
                                AsyncImage(url: viewModel.character.images[0]) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                                .clipShape(.rect(cornerRadius: 50))
                                
                                Text(viewModel.quote.character)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                                
                            }
                            // Set container size before clipping.
                            .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                            .clipShape(.rect(cornerRadius: 50))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                            
                        case .successEpisode:
                            EpisodeView(episode: viewModel.episode)
                        case .failed(error: let error):
                            Text(error.localizedDescription)
                        }
                        Spacer(minLength: 20)
                    }
                    
                    // Button triggers fetch
                    HStack {
                        Button {
                            Task {
                                // Use Task to call async function from button tap.
                                await viewModel.getQuoteData(for: show)
                            }
                        } label: {
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
                                // Use Task to call async function from button tap.
                                await viewModel.getEpisode(for: show)
                            }
                        } label: {
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
                    .padding(.horizontal, 30)
                    // Keep space above tab bar.
                    Spacer(minLength: 95)
                }
                // Keep content sized to screen (background is larger).
                .frame(width: geo.size.width, height: geo.size.height)
            }
            // Keep container sized to screen.
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .toolbarBackgroundVisibility(.visible, for: .tabBar) // Keep tab bar visible. Placing it here avoids repeating in each tab.
        .sheet(isPresented: $showCharacterInfo) {
            // Present CharacterView when tapped.
            CharacterView(character: viewModel.character, show: show)
        }
    }
}

#Preview {
    FetchView(show: Constants.bbName)
        .preferredColorScheme(.dark)
}
