//
//  FetchRecipeDetailsData.swift
//  FridgeButler
//
//  Created by Yao Zhang on 5/27/24.
//

import Foundation
import SwiftUI

class FetchRecipeDetailsData: ObservableObject {
    @Published var recipeDetail: RecipeDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchRecipeDetail(recipeId: Int) {
        self.isLoading = true
        self.errorMessage = nil
        let urlString = "https://api.spoonacular.com/recipes/\(recipeId)/information?includeNutrition=false&apiKey=2c0dfbebbd064eeab2567ca61f6cd9db"
        
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                
                do {
                    let recipeDetail = try JSONDecoder().decode(RecipeDetail.self, from: data)
                    self.recipeDetail = recipeDetail
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }.resume()
    }
}
