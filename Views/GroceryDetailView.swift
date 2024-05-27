//
//  GroceryDetailView.swift
//  FridgeButler
//
//  Created by Yao Zhang on 5/26/24.
//

import SwiftUI

struct GroceryDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: GroceryViewModel
    @State var groceryItem: GroceryListItem
    
    var body: some View {
        Form {
            TextField("Name", text: $groceryItem.name)
            TextField("Quantity", value: $groceryItem.quantity, formatter: NumberFormatter())
            TextField("Per", text: $groceryItem.per)
            DatePicker("Expiration Date", selection: $groceryItem.expirationDate, displayedComponents: .date)
            Picker("Status", selection: $groceryItem.status) {
                Text("Unused").tag("unused")
                Text("Used").tag("used")
                Text("Wasted").tag("wasted")
            }
            
            Button("Save") {
                if groceryItem.id.isEmpty {
                    viewModel.addGroceryItem(groceryItem)
                } else {
                    viewModel.updateGroceryItem(groceryItem)
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}


