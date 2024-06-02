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
            HStack {
                Text("Item Name:")
                    .bold ()
                    .foregroundColor(.black)
                TextField ("Name", text: $groceryItem.name)
            }
            HStack {
                Text("Quantity:")
                    .bold()
                TextField ("Number", value: $groceryItem.quantity, formatter: NumberFormatter()) .keyboardType(.numberPad)
                TextField("Unit", text: $groceryItem.per)
            }
                DatePicker("Expiration Date", selection: $groceryItem.expirationDate, displayedComponents: .date)
                Picker("Status", selection: $groceryItem.status) {
                    Text( "Unused").tag("unused")
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
                              
