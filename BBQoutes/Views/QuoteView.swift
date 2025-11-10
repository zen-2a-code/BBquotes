//
//  QuoteView.swift
//  BBQoutes
//
//  Created by Stoyan Hristov on 8.11.25.
//

import SwiftUI

struct QuoteView: View {
    let viewModel = ViewModel()
    let show: String
    
        var body: some View {
            // give us an access to our screen size
            GeometryReader { geo in
                ZStack {
                    // Oversized background image makes the ZStack larger than the screen.
                    // That can cause text to think it has a huge width and not wrap at the screen edges.
                    Image(show.lowercased().replacingOccurrences(of: " ", with: ""))
                        .resizable()
                        .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)

                    // Put the text in a VStack and CONSTRAIN its width to the screen.
                    // This gives Text a real width to wrap within, so long lines break onto the next line.
                    VStack {
                        // The quote text. It will now wrap because the VStack is limited to screen width.
                        Text("\"\(viewModel.quote.quote ) \"")
                            // 1) Align the text inside its available width.
                            // This only affects how lines are aligned, not the size of the view.
                            .multilineTextAlignment(.center)

                            // 2) Set the text color before adding backgrounds so the text stays readable.
                            .foregroundColor(.white)

                            // 3) Add inner padding first so the background has some space around the text.
                            // If you put background before padding, the background would hug the text tightly.
                            .padding()

                            // 4) Add a translucent background behind the padded text.
                            // Order matters: because padding came first, the background includes that padding.
                            .background(.black.opacity(0.5))

                            // 5) Clip the background to a rounded shape.
                            // We clip after background so the rounded corners apply to the background too.
                            // If you clipped before background, the background would ignore the clipping.
                            .clipShape(RoundedRectangle(cornerRadius: 25))

                            // 6) Add outer padding last to separate this whole bubble from the screen edges.
                            // If you put this padding before background, you'd get a bigger background instead.
                            .padding(.horizontal)
                        
                        ZStack (alignment: .bottom) {
                            
                            AsyncImage(url: viewModel.character.images[0]) { image in
                                image
                                // Allow the image to change size so it can fit the frame we set later.
                                    .resizable()
                                // Fill the given space while keeping the image's aspect ratio. May crop edges.
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            // Size the image relative to the screen:
                            // - width/1.1 ≈ 91% of screen width (slightly smaller to add margins)
                            // - height/1.8 ≈ 56% of screen height (a bit over half, not exactly half)
                            // Using divisors like 1.1 and 1.8 is a quick way to scale; tweak them to get the look you want.
                            .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                            .clipShape(.rect(cornerRadius: 50))
                            
                            Text(viewModel.quote.character)
                                // Make the text readable over the image.
                                .foregroundStyle(.white)
                                // Inner spacing around the text so the background doesn't hug the letters (mostly vertical).
                                .padding(10)
                                // Expand the label to the full width of this ZStack so the background spans edge‑to‑edge.
                                // If you remove this, the background will only be as wide as the text + padding.
                                .frame(maxWidth: .infinity)
                                // Put a material background behind the (now full‑width) label.
                                // Background comes after padding so it includes that inner space.
                                .background(.ultraThinMaterial)

                        }
                        // Important: set an explicit frame on the container BEFORE clipping.
                        // Clipping uses the view's current size. Without this frame, the ZStack can be larger
                        // than the visible image (due to image scaling/overflow), so the rounded rect could
                        // appear wider than the image (those ~20px extra on the sides).
                        .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                        // Now that the container has the exact size we want, clip it to rounded corners.
                        // This trims both the image and the label background to the same rounded shape.
                        .clipShape(.rect(cornerRadius: 50))
                        
                    }
                    .frame(width: geo.size.width) // Key: limit VStack to screen width so the text wraps.
                }
                // Keep the ZStack itself the size of the screen to center everything.
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .ignoresSafeArea()
        }
    }

    #Preview {
        QuoteView(show: "Breaking Bad")
            .preferredColorScheme(.dark)
    }

