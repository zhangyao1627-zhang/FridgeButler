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
    @Published var unusedGroceryNames: [String] = []

    private var db = Firestore.firestore()

    // Fetch data from Firestore
    func fetchData() {
        fetchGroceryItems()
        fetchReceiptItems()
        fetchShoppingItems()
        fetchUnusedGroceryNames()
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

    private func fetchUnusedGroceryNames() {
        db.collection("groceryItems").whereField("status", isEqualTo: "unused").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.unusedGroceryNames = querySnapshot.documents.compactMap { document -> String? in
                    let item = try? document.data(as: GroceryListItem.self)
                    return item?.name
                }
            } else if let error = error {
                print("Error getting documents: \(error)")
            }
        }
    }
    
    // Add a new GroceryListItem
    func addGroceryItem(_ item: GroceryListItem) {
        do {
            print("Enter Here for details")
            let _ = try db.collection("groceryItems").document(item.id).setData(from: item)
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
                }
            }
        }
    }
    
    // Update a GroceryListItem
    func updateGroceryItem(_ item: GroceryListItem) {
        do {
            let _ = try db.collection("groceryItems").document(item.id).setData(from: item)
        } catch {
            print("Error updating grocery item: \(error)")
        }
    }

}
