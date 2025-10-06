//
//  collection.swift
//  quote-currency
//
//  Created by Terence Dreico Borjal on 10/4/25.
//
import SwiftUI

struct CollectionView: View {
    @State private var savedImages: [SavedImage] = []

    var body: some View {
        VStack {
            Text("My Collection")
                .font(.title)
            if savedImages.isEmpty {
                Text("No saved images yet.")
                    .foregroundColor(.secondary)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                        ForEach(savedImages) { image in
                            Image(image.name)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear(perform: reload)
        .onReceive(NotificationCenter.default.publisher(for: .savedImagesDidChange)) { _ in
            reload()
        }
    }
    // Automatic checking of the SavedImages 
    private func reload() {
        savedImages = SavedImageStorage.load()
    }
}

extension Notification.Name {
    static let savedImagesDidChange = Notification.Name("savedImagesDidChange")
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
