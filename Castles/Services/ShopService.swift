//
//  ShopService.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-31.
//

import Foundation
import Combine

protocol ShopService {
  var shopPublisher: AnyPublisher<[ShopItem], Never> { get }
  func decreaseQuantity(for: ShopItem)
  func refreshStore()
}

final class ShopServiceAdapter: ShopService {
  static let shared = ShopServiceAdapter()
  
  private var items: [ShopItem] = [] {
    didSet {
      currentValueItems.value = items
      saveData()
    }
  }
  private var fileURL: URL {
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return URL(fileURLWithPath: "shopItems", relativeTo: directory)
  }
  private var currentValueItems = CurrentValueSubject<[ShopItem], Never>([])
  var shopPublisher: AnyPublisher<[ShopItem], Never> { currentValueItems.eraseToAnyPublisher() }
  
  private init() {
    self.retrieveData()
  }
  
  func decreaseQuantity(for item: ShopItem) {
    guard let index = items.firstIndex(where: { $0.itemID == item.itemID }) else { return }
    var newItem = items[index]
    newItem.quantity -= 1
    items[index] = newItem
  }
  
  func refreshStore() {
    self.items = ShopServiceAdapter.refreshedItems()
  }
}

private extension ShopServiceAdapter {
  static func refreshedItems() -> [ShopItem] {
    return [
      ShopItem(itemID: UUID().uuidString, quantity: 2, price: 200, name: "Small attack increase", wrappedItem: AttackItem(attackIncrease: 20)),
      ShopItem(itemID: UUID().uuidString, quantity: 1, price: 400, name: "Attack increase", wrappedItem: AttackItem(attackIncrease: 50)),
      ShopItem(itemID: UUID().uuidString, quantity: 2, price: 200, name: "Small defense increase", wrappedItem: DefenseItem(defenseIncrease: 20)),
      ShopItem(itemID: UUID().uuidString, quantity: 1, price: 200, name: "Defense increase", wrappedItem: DefenseItem(defenseIncrease: 50)),
      ShopItem(itemID: UUID().uuidString, quantity: 1, price: 500, name: "Castle HP Recovery", wrappedItem: HPItem(hpIncrease: 40))
    ]
  }
  
  func retrieveData() {
//    if let data = try? Data(contentsOf: fileURL), let items = try? JSONDecoder().decode([ShopItem].self, from: data) {
//      self.items = items
//    } else {
//      self.items = ShopServiceAdapter.refreshedItems()
//    }
  }
  
  func saveData() {
//    do {
//      let data = try JSONEncoder().encode(items)
//      try data.write(to: fileURL)
//    } catch {
//      print("Error saving! \(error)")
//    }
  }
}
