//
//  RecipeCardLabelView.swift
//  FridgeButler
//
//  Created by Yao Zhang on 6/2/24.
//

import SwiftUI

struct RecipeCardLabelView: View {
    
    var recipe: RecipeListItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "heart")
                Text("Likes: \(recipe.likes)")
            }
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "checkmark.circle")
                Text("UnusedItem: \(recipe.usedIngredientCount)")
            }
            HStack(alignment: .center, spacing: 2) {
                Image(systemName: "exclamationmark.circle")
                Text("MissingItem: \(recipe.missedIngredientCount)")
            }
        }
        .font(.footnote)
        .foregroundColor(Color.gray)
    }
    
}
