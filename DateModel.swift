//
//  DateModel.swift
//  FridgeButler
//
//  Created by Yao Zhang on 5/26/24.
//

import Foundation

struct GroceryListItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var quantity: Int
    var per: String
    var expirationDate: Date
    var status: String // "unused", "used", or "wasted"
}

struct RecipeListItem: Identifiable, Codable {
    var id: Int
    var title: String
    var usedIngredients: [String]
    var usedIngredientCount: Int
    var missedIngredients: [String]
    var missedIngredientCount: Int
}

// to help decode the file
struct RawRecipe: Codable {
    var id: Int
    var title: String
    var image: String
    var usedIngredients: [Ingredient]
    var missedIngredients: [Ingredient]
}

struct Ingredient: Codable {
    var name: String
    var amount: Double
    var unit: String
}

struct IngredientLabel: Hashable {
    let name: String
    let isUsed: Bool
}

struct ShoppingListItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
}

struct RecipeDetail: Decodable {
    let title: String
    let image: String
    let summary: String
}
