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
            Group {
                if fetchData.isLoading {
                    ProgressView("Loading...")
                } else {
                    List(fetchData.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipeId: recipe.id)) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(recipe.title)
                                        .font(.headline)
                                    Spacer()
                                    Button(action: {
                                        // Add functionality
                                    }) {
                                        Image(systemName: "plus.circle")
                                    }
                                }
                                TagsView(items: recipe.usedIngredients.map { IngredientLabel(name: $0, isUsed: true) } + recipe.missedIngredients.map { IngredientLabel(name: $0, isUsed: false) })
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .navigationBarTitle("Recipes")
            .onAppear {
                fetchData.fetchRecipes(ingredients: viewModel.unusedGroceryNames)
            }
        }
    }
}

struct TagsView: View {
    let items: [IngredientLabel]
    var groupedItems: [[IngredientLabel]] = []
    let screenWidth = UIScreen.main.bounds.width
    
    init(items: [IngredientLabel]) {
        self.items = items
        self.groupedItems = createGroupedItems(items)
    }
    
    private func createGroupedItems(_ items: [IngredientLabel]) -> [[IngredientLabel]] {
        var groupedItems: [[IngredientLabel]] = []
        var tempItems: [IngredientLabel] = []
        var width: CGFloat = 0
        
        for item in items {
            let label = UILabel()
            label.text = item.name
            label.sizeToFit()
            
            let labelWidth = label.frame.size.width + 32 // Adjust for padding
            
            if (width + labelWidth + 55) < screenWidth {
                width += labelWidth
                tempItems.append(item)
            } else {
                width = labelWidth
                groupedItems.append(tempItems)
                tempItems.removeAll()
                tempItems.append(item)
            }
        }
        
        groupedItems.append(tempItems)
        return groupedItems
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(groupedItems, id: \.self) { subItems in
                    HStack {
                        ForEach(subItems, id: \.self) { item in
                            Text(item.name)
                                .fixedSize()
                                .padding()
                                .frame(height: 35)
                                .background(item.isUsed ? Color.green : Color.red)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        }
                    }
                }
                Spacer()
            }
        }
    }
}
