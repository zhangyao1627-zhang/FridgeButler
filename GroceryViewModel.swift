//
//  GroceryViewModel.swift
//  FridgeButler
//
//  Created by Yao Zhang on 5/26/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class GroceryViewModel: ObservableObject {

    @Published var groceryList: [GroceryListItem] = []
    @Published var receiptList: [RecipeListItem] = []
    @Published var shoppingList: [ShoppingListItem] = []
    @Published var historyList: [GroceryListItem] = []
    @Published var showAlert: Bool = false
    @Published var alertMsg: String = ""

    private var db = Firestore.firestore()

    // Fetch data from Firestore
    func fetchData() {
        fetchGroceryItems()
        fetchReceiptItems()
        fetchShoppingItems()
    }

    private func fetchGroceryItems() {
        db.collection("groceryItems").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.groceryList = querySnapshot.documents.compactMap { document -> GroceryListItem? in
                    try? document.data(as: GroceryListItem.self)
                }
            }
        }
    }

    private func fetchReceiptItems() {
        db.collection("receiptItems").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.receiptList = querySnapshot.documents.compactMap { document -> RecipeListItem? in
                    try? document.data(as: RecipeListItem.self)
                }
            }
        }
    }

    private func fetchShoppingItems() {
        db.collection("shoppingItems").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.shoppingList = querySnapshot.documents.compactMap { document -> ShoppingListItem? in
                    try? document.data(as: ShoppingListItem.self)
                }
            }
        }
    }
    
    // Add a new GroceryListItem
    func addGroceryItem(_ item: GroceryListItem) {
        do {
            print("Enter Here for details")
            let _ = try db.collection("groceryItems").document(item.id).setData(from: item)
            groceryList.append(item)
        } catch {
            print("Error adding grocery item: \(error)")
        }
    }
    
    // Delete a GroceryListItem
    func deleteGroceryItem(at offsets: IndexSet) {
        offsets.map { groceryList[$0] }.forEach { item in
            db.collection("groceryItems").document(item.id).delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    // Remove the item from the local list
                    DispatchQueue.main.async {
                        if let index = self.groceryList.firstIndex(where: { $0.id == item.id }) {
                            self.groceryList.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    
    func deleteHistoryItem(at offsets: IndexSet) {
        offsets.map { historyList[$0] }.forEach { item in
            db.collection("groceryItems").document(item.id).delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    // Remove the item from the local list
                    DispatchQueue.main.async {
                        if let index = self.historyList.firstIndex(where: { $0.id == item.id }) {
                            self.historyList.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    
    // Update a GroceryListItem
    func updateGroceryItem(_ item: GroceryListItem) {
        do {
            try db.collection("groceryItems").document(item.id).setData(from: item) { error in
                if let error = error {
                    print("Error updating grocery item: \(error)")
                } else {
                    // Update the item in the local list
                    DispatchQueue.main.async {
                        if let index = self.groceryList.firstIndex(where: { $0.id == item.id }) {
                            self.groceryList[index] = item
                        }
                        if item.status == "used" || item.status == "wasted" {
                            // Remove from groceryList and add to historyList
                            if let index = self.groceryList.firstIndex(where: { $0.id == item.id }) {
                                self.groceryList.remove(at: index)
                                self.historyList.append(item)
                            }

                            // Show alert if status is "wasted"
                            if item.status == "wasted" {
                                self.alertMsg = "Please don't do this again. \(item.name) is sad."
                                self.showAlert = true
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error updating grocery item: \(error)")
        }
    }

    // Add a new ShoppingListItem
    func addShoppingItem(_ item: ShoppingListItem) {
        do {
            let _ = try db.collection("shoppingItems").document(item.id).setData(from: item)
        } catch {
            print("Error adding shopping item: \(error)")
        }
    }

    // Delete a ShoppingListItem
    func deleteShoppingItem(at offsets: IndexSet) {
        offsets.map { shoppingList[$0] }.forEach { item in
            db.collection("shoppingItems").document(item.id).delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }
            }
        }
    }

    // Update a ShoppingListItem
    func updateShoppingItem(_ item: ShoppingListItem) {
        do {
            let _ = try db.collection("shoppingItems").document(item.id).setData(from: item)
            
        } catch {
            print("Error updating shopping item: \(error)")
        }
    }

}
