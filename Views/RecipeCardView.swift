//
//  RecipeCardView.swift
//  FridgeButler
//
//  Created by Yao Zhang on 6/2/24.
//

import SwiftUI

struct RecipeCardView: View {
    
    @EnvironmentObject var viewModel: GroceryViewModel
    var recipe: RecipeListItem
    @State private var showModal: Bool = false
    
    var body: some View {
      VStack(alignment: .leading, spacing: 0) {
        
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
        
        VStack(alignment: .leading, spacing: 12) {
          Text(recipe.title)
            .font(.system(.title, design: .serif))
            .fontWeight(.bold)
            .foregroundColor(.blue)
            
          RecipeCardLabelView(recipe: recipe)
                .environmentObject(viewModel)
        }
        .padding()
        .padding(.bottom, 12)
      }
      .background(Color.white)
      .cornerRadius(12)
      .shadow(color: .blue, radius: 8, x: 0, y: 0)
      .onTapGesture {
        self.showModal = true
      }
      .sheet(isPresented: self.$showModal) {
          RecipeCardDetailView(recipe: self.recipe, isPresented: self.$showModal)
      }
    }
  }



