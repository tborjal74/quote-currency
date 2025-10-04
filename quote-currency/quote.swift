//
//  quote.swift
//  quote-currency
//
//  Created by Terence Dreico Borjal on 10/3/25.
//

import SwiftUI
import Photos

struct QuoteView: View {
    @State private var currentImageIndex = 0
    @State private var showSavedPrompt = false
    let images = ["image-1", "image2", "image-3", "image-4", "image5", "image-6", "image-7", "image-8"]
    
    var body: some View {
        VStack {
            
            Label("Inspirational Quotes", systemImage: "pencil")
                .font(.title)
                .padding()
            Spacer()
            
            // Fixed-size container for the image
            ZStack {
                Color(.systemGray6)
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
                Button("Save to Photos") {
                    if let image = UIImage(named: images[currentImageIndex]) {
                        saveToPhotoLibrary(image)
                    } else {
                        print("Failed to load image named \(images[currentImageIndex])")
                    }
                }
                .buttonStyle(.bordered)
                
                .frame(maxWidth: 150, maxHeight: 10)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(20)
                
                Button("Save to Collection") {
                    SavedImageStorage.save(imageName: images[currentImageIndex])
                    showSavedPrompt = true
                }
                .alert("Photo saved!", isPresented: $showSavedPrompt) { }
                
                .buttonStyle(.bordered)
                
                .frame(maxWidth: 170, maxHeight: 10)
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
                .padding(.bottom, 30)
            }
            .background(Color.white.ignoresSafeArea())
        }
    }
    
    private func saveToPhotoLibrary(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized, .limited:
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            default:
                print("Permission to access photo library denied.")
            }
        }
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}
