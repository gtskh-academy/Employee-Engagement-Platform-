//
//  CachedAsyncImage.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: String?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @State private var image: UIImage?
    @State private var isLoading = true
    
    init(
        url: String?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else if isLoading {
                placeholder()
            } else {
                placeholder()
            }
        }
        .onAppear {
            loadImage()
        }
        .onChange(of: url) { _, _ in
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let urlString = url, !urlString.isEmpty,
              let imageURL = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        if let cachedImage = ImageCache.shared.get(forKey: urlString) {
            self.image = cachedImage
            self.isLoading = false
            return
        }
        
        isLoading = true
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                if let loadedImage = UIImage(data: data) {
                    ImageCache.shared.set(loadedImage, forKey: urlString)
                    await MainActor.run {
                        self.image = loadedImage
                        self.isLoading = false
                    }
                } else {
                    await MainActor.run {
                        self.isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}

