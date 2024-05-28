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
                                .font(.title) // Smaller font size
                                .fontWeight(.bold)
                                .padding(.top)
                                .padding(.horizontal)
                            
                    if let url = URL(string: recipeDetail.image) {
                        AsyncImage(url: url)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 300, maxHeight: 200) // Smaller image size
                            .clipped()
                            .padding(.vertical)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
            
                    HTMLTextR(html: recipeDetail.summary)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
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
            }.padding()
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


struct HTMLTextR: View {
    var html: String

    var body: some View {
        if let nsAttributedString = try? NSAttributedString(data: Data(html.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil),
           let attributedString = try? AttributedString(nsAttributedString) {
            ScrollView {
                Text(attributedString)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
            }
        } else {
            Text(html)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.body)
        }
    }
}
