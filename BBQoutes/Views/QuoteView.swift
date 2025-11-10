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
                    // Oversized background image ahead: it will make the ZStack's layout larger than the screen.
                    // That can trick child views (like Text) into thinking they have a huge width, hurting line wrapping.
                    Image(show.lowercased().replacingOccurrences(of: " ", with: ""))
                        .resizable()
                        // This image intentionally exceeds the screen to achieve the visual look,
                        // but it also expands the ZStack's layout size. That's why we add matching frames to ZStack and VStack.
                        // If this is purely decorative, disable interaction so it never intercepts touches:
                        // .allowsHitTesting(false)
                        .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)

                    // Put content in a VStack and CONSTRAIN it to the screen size.
                    // This gives Text a real width to wrap within so long lines break correctly.
                    VStack {
                        // Top spacer with a minimum height so content clears the Dynamic Island/status area.
                        // minLength is the minimum spacing; it can expand if more room is available.
                        Spacer(minLength: 60)
                        
                        // The quote text. It will now wrap because the VStack is limited to screen width.
                        Text("\"\(viewModel.quote.quote ) \"")
                            // Let the text shrink (down to 50%) instead of truncating when space is tight.
                            // Use this to keep long quotes readable without ellipses.
                            .minimumScaleFactor(0.5)
                            // Align lines within the available width; this doesn't change the view's size.
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
                            // - height/1.8 ≈ 56% of screen height (a bit over half)
                            // Using divisors like 1.1 and 1.8 is a quick way to scale; tweak them to taste.
                            .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                            .clipShape(.rect(cornerRadius: 50))
                            
                            Text(viewModel.quote.character)
                                // Make the text readable over the image.
                                .foregroundStyle(.white)
                                // Inner spacing around the text so the background doesn't hug the letters (mostly vertical).
                                .padding(10)
                                // Put a material background behind the full‑width label.
                                // Background comes after padding so it includes that inner space.
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)

                        }
                        // Important: set an explicit frame on the container BEFORE clipping.
                        // Clipping uses the view's current size. Without this frame, the ZStack can be larger
                        // than the visible image (due to scaling overflow), so the rounded rect could appear wider than the image.
                        .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                        // Now that the container has the exact size we want, clip it to rounded corners.
                        // This trims both the image and the label background to the same rounded shape.
                        .clipShape(.rect(cornerRadius: 50))
                        
                        // Extra spacing between the image card and the button so they don't hug the edges.
                        // minLength guarantees at least this much breathing room on small screens.
                        Spacer(minLength: 16)
                        
                        // Button best practice: use the label closure to wrap ALL visual content.
                        // Then the entire label (padding + background) participates in hit-testing.
                        // In the old version, overlapping layers could cover the text-only button, so only parts of the green area responded.
                        Button {
                            
                        } label: {
                            // Everything inside here is the tappable label. Keep visuals inside so tap area matches what users see.
                            Text("Get Random Quote")
                                .font(.title)
                                .foregroundStyle(.white)
                                // Inner padding makes the button bigger and increases the hit target.
                                .padding()
                                // Keep the background INSIDE the label so it's part of the tappable region.
                                .background(.breakingBadGreen)
                                // Clip the background to a rounded rect for the visual shape.
                                .clipShape(.rect(cornerRadius: 7))
                                // Make the tap target match the rounded shape (not just the text bounds).
                                .contentShape(.rect(cornerRadius: 7))
                                // Visual polish only; shadows don't affect hit-testing.
                                .shadow(color: .breakingBadYellow, radius: 2)
                        }
                        // Reserve extra space so the button clears the TabView and safe area.
                        // minLength keeps the button comfortably above bottom UI.
                        Spacer(minLength: 95)
                        
                        // Why the old approach felt unresponsive:
                        // - The oversized background image and the image container above can extend over the button area.
                        // - Even if they look transparent (materials, clipping), they can intercept touches.
                        // - By keeping the background inside the label and defining a contentShape, the full green area becomes the hit target.
                        // Best practices:
                        // - Keep button visuals inside the label closure.
                        // - Use contentShape to align tap area with the visible shape.
                        // - If a sibling view is purely decorative, consider .allowsHitTesting(false) on it to avoid stealing taps.
                    }
                    // Constrain the VStack to the screen too.
                    // The oversized background image expands layout; stacks size to their children.
                    // Without this, the VStack would stretch to the image's size (≈2.7x width, 1.2x height),
                    // and your text/button would stop obeying screen bounds.
                    .frame(width: geo.size.width, height: geo.size.height)
                }
                // Keep the ZStack the size of the screen to re-center content under GeometryReader.
                // We still need this even though the background image grows beyond it.
                // The ZStack's frame sets the centering baseline; the image extends visually beyond it.
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .ignoresSafeArea()
        }
    }

    #Preview {
        QuoteView(show: "Breaking Bad")
            .preferredColorScheme(.dark)
    }
