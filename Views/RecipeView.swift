//
//  ReceiptView.swift
//  FridgeButler
//
//  Created by Yao Zhang on 5/22/24.
//

import SwiftUI

struct RecipeView: View {
    @StateObject private var fetchData = FetchRecipeData()
    @EnvironmentObject var viewModel: GroceryViewModel
   
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                if fetchData.isLoading {
                    ProgressView("Loading...")
                } else {
                    VStack(alignment: .center, spacing: 20) {
                        ForEach(fetchData.recipes) { item in
                            RecipeCardView(recipe: item)
                                .environmentObject(viewModel)
                        }
                    }
                    .frame(maxWidth: 640)
                    .padding(.horizontal)
                }
            }
            .navigationBarTitle("Recipes")
            .onAppear {
                fetchData.fetchRecipes(ingredients: viewModel.groceryList.map { $0.name })
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) 
    }
    
    private func addIngredientsToShoppingList(recipe: RecipeListItem) {
        for ingredient in recipe.missedIngredients {
            let newShoppingItem = ShoppingListItem(id: UUID().uuidString, name: ingredient)
            viewModel.addShoppingItem(newShoppingItem)
        }
    }
}

