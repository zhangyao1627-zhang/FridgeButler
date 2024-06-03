//
//  RecipeDetailView.swift
//  FridgeButler
//
//  Created by Yao Zhang on 6/2/24.
//

import SwiftUI

struct RecipeCardDetailView: View {
    
    var recipe: RecipeListItem
    @Binding var isPresented: Bool 
    @StateObject private var fetchData = FetchRecipeDetailsData()
    @EnvironmentObject var viewModel: GroceryViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 0) {
                // IMAGE
                if let url = URL(string: recipe.image) {
                    AsyncImage(url: url)
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .overlay(
                      HStack {
                        Spacer()
                        VStack {
                          Image(systemName: "bookmark")
                            .font(Font.title.weight(.light))
                            .foregroundColor(Color.white)
                            .imageScale(.small)
                            .shadow(color: .blue, radius: 2, x: 0, y: 0)
                            .padding(.trailing, 20)
                            .padding(.top, 22)
                          Spacer()
                        }
                      }
                    )
                }
                
                Group {
                    
                    Text(recipe.title)
                        .font(.system(.largeTitle, design: .serif))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                    
                    RecipeCardLabelView(recipe: recipe)
                    
                    Text("Ingredients Reused")
                        .fontWeight(.bold)
                        .modifier(TitleModifier())
                    
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(recipe.usedIngredients, id: \.self) { item in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(item)
                                    .font(.footnote)
                                    .multilineTextAlignment(.leading)
                                Divider()
                            }
                        }
                    }
                    
                    Text("Ingredients Missed")
                        .fontWeight(.bold)
                        .modifier(TitleModifier())
                    
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(recipe.missedIngredients, id: \.self) { item in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(item)
                                    .font(.footnote)
                                    .multilineTextAlignment(.leading)
                                Divider()
                            }
                        }
                    }
                    
                    // INSTRUCTIONS
                    Text("Details")
                        .fontWeight(.bold)
                        .modifier(TitleModifier())
                
                    if let recipeDetail = fetchData.recipeDetail {
                        HTMLTextR(html: recipeDetail.summary)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.systemBackground))
                    }
                    
                    Button(action: {
                        self.isPresented = false
                        addIngredientsToShoppingList(recipe: recipe)
                    }) {
                        Text("Add Recipe")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .padding()
                            .background(Capsule().fill(Color.blue))
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)

            }
        }
        .onAppear {
            fetchData.fetchRecipeDetail(recipeId: recipe.id)
        }
    }
    
    private func addIngredientsToShoppingList(recipe: RecipeListItem) {
        for ingredient in recipe.missedIngredients {
            let newShoppingItem = ShoppingListItem(id: UUID().uuidString, name: ingredient)
            viewModel.addShoppingItem(newShoppingItem)
        }
    }
    
}


struct HTMLTextR: View {
    var html: String

    var body: some View {
        if let nsAttributedString = try? NSAttributedString(data: Data(html.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil),
           let attributedString = try? AttributedString(nsAttributedString) {
            ScrollView {
                Text(attributedString)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 30, design: .serif))
//                    .frame(minHeight: 150)
            }
        } else {
//            Text(html)
//                .lineLimit(nil)
//                .multilineTextAlignment(.center)
//                .font(.system(size: 30, design: .serif))
//                .frame(minHeight: 150)
        }
    }
}
