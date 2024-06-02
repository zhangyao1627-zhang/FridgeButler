//
//  GroceryView.swift
//  FridgeButler
//
//  Created by Yao Zhang on 5/22/24.
//

import SwiftUI

struct GroceryView: View {
    
    
@State private var isPresentingAddGroceryItem = false
@EnvironmentObject var viewModel: GroceryViewModel

var body: some View {
    NavigationView {
        List {
            Section (header: VStack(alignment: .leading) {
                Text("Today's date is")
                    .font(.headline)
                Text (todayDateString)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }.textCase (nil)) {
                ForEach(viewModel.groceryList) { item in
                    NavigationLink(destination: GroceryDetailView(viewModel: viewModel, groceryItem: item)) {
                        Text(item.name)
                    }
                    }
                            .onDelete(perform: viewModel.deleteGroceryItem)
                    }
        }
                        
                            .navigationBarTitle("Your Fridge")
                            .navigationBarItems(trailing: Menu {
                                Button(action: {
                                    isPresentingAddGroceryItem = true
                                }) {
                                    Text("Add Grocery Item")
                                }
                            } label: {
                                Image(systemName: "plus")
                            })
                            .sheet(isPresented: $isPresentingAddGroceryItem) {
                                GroceryDetailView(viewModel: viewModel, groceryItem: GroceryListItem(name: "", quantity: 1, per: "", expirationDate: Date(), status: "unused"))
                            }
                    }
                }
            }
private var todayDateString: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter.string(from: Date())
}
