//
//  ShoppingListView.swift
//  FridgeButler
//
//  Created by Yao Zhang on 5/22/24.
//

import SwiftUI
import FirebaseCore

struct ShoppingListView: View {
    @EnvironmentObject var viewModel: GroceryViewModel
    @State private var newItem: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Shopping List")
                    .fontWeight(.bold)
                    .modifier(TitleModifier())
                
                List {
                    HStack {
                        TextField("Enter new item", text: $newItem, onCommit: addItem)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: addItem) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title)
                        }
                    }
                    .padding()

                    ForEach(viewModel.shoppingList) { item in
                        Text(item.name)
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationBarTitle("Shopping List")
            }
        }
    }

    private func addItem() {
        guard !newItem.isEmpty else { return }
        let newShoppingItem = ShoppingListItem(id: UUID().uuidString, name: newItem)
        viewModel.addShoppingItem(newShoppingItem)
        newItem = ""
    }

    private func deleteItems(at offsets: IndexSet) {
        viewModel.deleteShoppingItem(at: offsets)
    }
}
