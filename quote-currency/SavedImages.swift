//
//  quote_currencyApp.swift
//  quote-currency
//
//  Created by Terence Dreico Borjal on 10/4/25.
//

import Foundation

struct SavedImage: Identifiable, Codable {
    let id: UUID
    let name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

enum SavedImageStorage {
    private static let key = "SavedImages"

    static func save(imageName: String) {
        var images = load()
        if !images.contains(where: { $0.name == imageName }) {
            images.append(SavedImage(name: imageName))
            if let data = try? JSONEncoder().encode(images) {
                UserDefaults.standard.set(data, forKey: key)
                NotificationCenter.default.post(name: Notification.Name("savedImagesDidChange"), object: nil)
            }
        }
    }

    static func load() -> [SavedImage] {
        if let data = UserDefaults.standard.data(forKey: key),
           let images = try? JSONDecoder().decode([SavedImage].self, from: data) {
            return images
        }
        return []
    }
}
