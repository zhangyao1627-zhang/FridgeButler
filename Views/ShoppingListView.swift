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
    @State private var showingAddItemSheet = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Shopping List")
                    .fontWeight(.bold)
                    .modifier(TitleModifier())
                
                List {
                    ForEach(viewModel.shoppingList) { item in
                        Text(item.name)
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationBarItems(trailing: Button(action: {
                    showingAddItemSheet = true
                }) {
                    Image(systemName: "plus")
                })
            }
            .sheet(isPresented: $showingAddItemSheet) {
                AddItemView(showingSheet: $showingAddItemSheet, viewModel: viewModel)
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        viewModel.deleteShoppingItem(at: offsets)
    }
}

struct AddItemView: View {
    @Binding var showingSheet: Bool
    @EnvironmentObject var viewModel: GroceryViewModel
    @State private var newItem: String = ""

    var body: some View {
        VStack {
            Text("Add New Item")
                .font(.headline)
                .padding()
            
            TextField("Enter new item", text: $newItem)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("Add") {
                    addItem()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Cancel") {
                    showingSheet = false
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }

    private func addItem() {
        guard !newItem.isEmpty else { return }
        let newShoppingItem = ShoppingListItem(id: UUID().uuidString, name: newItem)
        viewModel.addShoppingItem(newShoppingItem)
        newItem = ""
        showingSheet = false
    }
}
