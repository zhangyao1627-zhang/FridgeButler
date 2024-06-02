//
//  FetchReciptData.swift
//  FridgeButler
//
//  Created by Yao Zhang on 5/26/24.
//

import Foundation

class FetchRecipeData: ObservableObject {
    
    @Published var recipes: [RecipeListItem] = []
    @Published var isLoading = false
    
    func fetchRecipes(ingredients: [String]) {
        let ingredientsString = ingredients.joined(separator: ",+")
        let urlString = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(ingredientsString)&number=5&apiKey=608215f62aab4865bc56d0918a509005"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let rawRecipes = try decoder.decode([RawRecipe].self, from: data)
                let recipes = rawRecipes.map { rawRecipe -> RecipeListItem in
                    let usedIngredientNames = rawRecipe.usedIngredients.map { $0.name }
                    let missedIngredientNames = rawRecipe.missedIngredients.map { $0.name }
                    
                    return RecipeListItem(
                        id: rawRecipe.id,
                        title: rawRecipe.title,
                        usedIngredients: usedIngredientNames,
                        usedIngredientCount: usedIngredientNames.count,
                        missedIngredients: missedIngredientNames,
                        missedIngredientCount: missedIngredientNames.count
                    )
                }
                DispatchQueue.main.async {
                    self.recipes = recipes
                    self.isLoading = false
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
