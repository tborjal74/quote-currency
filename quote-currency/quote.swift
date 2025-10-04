//
//  quote.swift
//  quote-currency
//
//  Created by Terence Dreico Borjal on 10/3/25.
//

import SwiftUI

struct QuoteView: View {
    @State private var currentImageIndex = 0
        let images = ["image5", "image2", "image-3, image-4, image5"] // image names in Assets
    
    var body: some View {
            VStack {
                
                Label("Inspirational Quotes", systemImage: "pencil")
                    .font(.title)
                    .padding()
                Spacer() // Pushes everything to center

                // Fixed-size container for the image
                ZStack {
                    Color(.systemGray6) // Optional: background to visualize the container
                    Image(images[currentImageIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
                .frame(width: 300, height: 300)
                .cornerRadius(16)
                .shadow(radius: 10)

                Spacer() 

                VStack {
                    Button("Save") {
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: 80, maxHeight: 10)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(20)
                Spacer()
                
            
                HStack(spacing: 40) {
                    Button("Previous") {
                        currentImageIndex = (currentImageIndex - 1 + images.count) % images.count
                    }
                    .buttonStyle(.bordered)

                    Button("Shuffle") {
                        currentImageIndex = Int.random(in: 0..<images.count)
                    }
                    .buttonStyle(.bordered)

                    Button("Next") {
                        currentImageIndex = (currentImageIndex + 1) % images.count
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.bottom, 30) // Fixed distance from bottom edge
            }
            .background(Color.white.ignoresSafeArea())
        }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}
