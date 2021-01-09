//
//  ShopItem.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-31.
//

import Foundation

private enum ItemType: Int {
  case attackItem
  case defenseItem
  case hpItem
}

struct ShopItem {
  let itemID: String
  var quantity: Int
  let price: Int
  let name: String
  private let type: ItemType
  private(set) var wrappedItem: Item
  
  init(itemID: String, quantity: Int, price: Int, name: String, wrappedItem: Item) {
    self.itemID = itemID
    self.quantity = quantity
    self.price = price
    self.name = name
    self.wrappedItem = wrappedItem
    switch wrappedItem {
    case _ as AttackItem:
      self.type = .attackItem
    case _ as DefenseItem:
      self.type = .defenseItem
    case _ as HPItem:
      self.type = .hpItem
    default:
      self.type = .attackItem
    }
  }
}

protocol Item {
  func accept<V: ItemVisitor>(visitor: V, data: V.Data) -> V.Outcome
}

protocol ItemVisitor {
  associatedtype Outcome
  associatedtype Data
  func visit(castleItem: CastleItem, data: Data) -> Outcome
}
