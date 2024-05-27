//
//  RecipeDetailsView.swift
//  FridgeButler
//
//  Created by Yao Zhang on 5/27/24.
//
import SwiftUI
import UIKit

struct RecipeDetailView: View {
    let recipeId: Int
    @StateObject private var fetchData = FetchRecipeDetailsData()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let recipeDetail = fetchData.recipeDetail {
                    Text(recipeDetail.title)
                        .font(.largeTitle)
                        .padding(.top)
                    
                    if let url = URL(string: recipeDetail.image) {
                        AsyncImage(url: url)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200) // Set the size of the image here
                            .clipped()
                            .padding(.vertical)
                    }
                    
                    HTMLText(html: recipeDetail.summary)
                        .padding(.horizontal)
                } else if fetchData.isLoading {
                    ProgressView()
                        .padding()
                } else if let errorMessage = fetchData.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("No data available")
                        .padding()
                }
            }
        }
        .onAppear {
            fetchData.fetchRecipeDetail(recipeId: recipeId)
        }
    }
}

struct AsyncImage: View {
    @StateObject private var loader: ImageLoader
    let placeholder: Image

    init(url: URL, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
    }

    private var image: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage).resizable()
            } else {
                placeholder
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func load() {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}

struct HTMLText: UIViewRepresentable {
    let html: String

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        let modifiedFont = String(format:"<span style=\"font-family: -apple-system; font-size: \(UIFont.preferredFont(forTextStyle: .body).pointSize)\">%@</span>", html)
        
        if let data = modifiedFont.data(using: .unicode) {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            
            if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                uiView.attributedText = attributedString
            }
        }
    }
}
