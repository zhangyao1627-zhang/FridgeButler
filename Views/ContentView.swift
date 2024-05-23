//
//  ContentView.swift
//  FridgeButler
//
//  Created by Yao Zhang on 5/22/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GroceryView()
                .tabItem {
                    Label("Grocery", systemImage: "cart.fill")
                }
            
            ReceiptView()
                .tabItem {
                    Label("Receipt", systemImage: "doc.text.fill")
                }
            
            ShoppingListView()
                .tabItem {
                    Label("Shopping List", systemImage: "list.bullet")
                }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
