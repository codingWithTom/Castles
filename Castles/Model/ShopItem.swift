//
//  ShopItem.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-31.
//

import Foundation

private enum ItemType: Int, Codable {
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

extension ShopItem: Codable {
  enum CodingKeys: String, CodingKey {
    case itemID, quantity, price, name, itemType, wrappedItem
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.itemID = try  container.decode(String.self, forKey: .itemID)
    self.quantity = try container.decode(Int.self, forKey: .quantity)
    self.price = try container.decode(Int.self, forKey: .price)
    self.name = try container.decode(String.self, forKey: .name)
    self.type = try container.decode(ItemType.self, forKey: .itemType)
    self.wrappedItem = AttackItem(attackIncrease: 0)
    self.wrappedItem = try self.decodeItem(with: decoder)
  }
  
  func decodeItem(with decoder: Decoder) throws -> Item {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    switch type {
    case .attackItem:
      return try container.decode(AttackItem.self, forKey: .wrappedItem)
    case .defenseItem:
      return try container.decode(DefenseItem.self, forKey: .wrappedItem)
    case .hpItem:
      return try container.decode(HPItem.self, forKey: .wrappedItem)
    }
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(itemID, forKey: .itemID)
    try container.encode(quantity, forKey: .quantity)
    try container.encode(price, forKey: .price)
    try container.encode(name, forKey: .name)
    try container.encode(type, forKey: .itemType)
    switch wrappedItem {
    case let attackItem as AttackItem:
      try container.encode(attackItem, forKey: .wrappedItem)
    case let defenseItem as DefenseItem:
      try container.encode(defenseItem, forKey: .wrappedItem)
    case let hpItem as HPItem:
      try container.encode(hpItem, forKey: .wrappedItem)
    default:
      break
    }
  }
}

protocol Item: Codable {
  func accept<V: ItemVisitor>(visitor: V, data: V.Data) -> V.Outcome
}

protocol ItemVisitor {
  associatedtype Outcome
  associatedtype Data
  func visit(castleItem: CastleItem, data: Data) -> Outcome
}

protocol CastleItem: Item {
  func accept<V: CastleItemVisitor>(visitor: V, data: V.Data) -> V.Outcome
}

struct AttackItem: CastleItem {
  let attackIncrease: Int
  
  func accept<V: CastleItemVisitor>(visitor: V, data: V.Data) -> V.Outcome  {
    visitor.visit(attackItem: self, data: data)
  }
  
  func accept<V>(visitor: V, data: V.Data) -> V.Outcome where V : ItemVisitor {
    visitor.visit(castleItem: self, data: data)
  }
}

struct DefenseItem: CastleItem {
  let defenseIncrease: Int
  
  func accept<V: CastleItemVisitor>(visitor: V, data: V.Data) -> V.Outcome  {
    visitor.visit(defenseItem: self, data: data)
  }
  
  func accept<V>(visitor: V, data: V.Data) -> V.Outcome where V : ItemVisitor {
    visitor.visit(castleItem: self, data: data)
  }
}

struct HPItem: CastleItem {
  let hpIncrease: Int
  
  func accept<V: CastleItemVisitor>(visitor: V, data: V.Data) -> V.Outcome  {
    visitor.visit(hpItem: self, data: data)
  }
  
  func accept<V>(visitor: V, data: V.Data) -> V.Outcome where V : ItemVisitor {
    visitor.visit(castleItem: self, data: data)
  }
}

protocol CastleItemVisitor {
  associatedtype Outcome
  associatedtype Data
  
  func visit(attackItem: AttackItem, data: Data) -> Outcome
  func visit(defenseItem: DefenseItem, data: Data) -> Outcome
  func visit(hpItem: HPItem, data: Data) -> Outcome
}
