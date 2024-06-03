//
//  ContentView.swift
//  FridgeButler
//
//  Created by Yao Zhang on 5/22/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = GroceryViewModel()
    
    var body: some View {
        TabView {
            GroceryView()
                .tabItem {
                    Label("Grocery", systemImage: "cart.fill")
                }
                .environmentObject(viewModel)
            
            RecipeView()
                .tabItem {
                    Label("Recipt", systemImage: "doc.text.fill")
                }
                .environmentObject(viewModel)
            
            ShoppingListView()
                .tabItem {
                    Label("Shopping List", systemImage: "list.bullet")
                }
                .environmentObject(viewModel)
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

struct TitleModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.system(.title, design: .serif))
      .foregroundColor(.blue)
      .padding(8)
  }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
