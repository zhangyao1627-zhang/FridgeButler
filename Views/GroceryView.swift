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
                Section(header: HStack {
                    VStack(alignment: .leading) {
                        Text("Current Inventory")
                            .font(.headline)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(todayDateString)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }.textCase (nil)) {
                    ForEach(viewModel.groceryList) { item in
                        NavigationLink(destination: GroceryDetailView(viewModel: viewModel, groceryItem: item)) {
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text(expirationDateString(for: item.expirationDate))
                                    .foregroundColor(color(for: item.expirationDate))
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteGroceryItem)
                }
                
                if !viewModel.historyList.isEmpty {
                    // History Section
                    Section(header: Text("History").font(.headline).textCase(nil)) {
                        ForEach(viewModel.historyList) { item in
                            HStack {
                                VStack(alignment: .leading, content: {
                                    Text(item.name)
                                        .foregroundColor(.gray)
                                })
                                Spacer()
                                VStack(alignment: .trailing, content: {
                                    Text(item.status == "wasted" ? "😢" : "🎉")
                                })
                            }
                        }
                        .onDelete(perform: viewModel.deleteGroceryItem)
                    }
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
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Hey"),
                    message: Text(viewModel.alertMsg),
                    dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private var todayDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    private func expirationDateString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }

    private func color(for date: Date) -> Color {
        let calendar = Calendar.current
        let today = Date()
        let daysUntilExpiration = calendar.dateComponents([.day], from: today, to: date).day ?? 0

        switch daysUntilExpiration {
        case ..<1:
            return .red
        case 1...3:
            return .orange
        default:
            return .green
        }
    }
}
