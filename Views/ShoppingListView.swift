//
//  ShoppingListView.swift
//  FridgeButler
//
//  Created by Yao Zhang on 5/22/24.
//

import SwiftUI

struct ShoppingListView: View {
    @State private var newItem: String = ""
    @State private var shoppingList: [String] = []

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter new item", text: $newItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: addItem) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                    .padding()
                }
                List {
                    ForEach(shoppingList, id: \.self) { item in
                        Text(item)
                    }
                }
                .navigationBarTitle("Shopping List")
            }
        }
    }

    private func addItem() {
        guard !newItem.isEmpty else { return }
        shoppingList.append(newItem)
        newItem = ""
    }
}
