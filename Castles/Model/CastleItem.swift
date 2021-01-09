//
//  CastleItem.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-09.
//

import Foundation

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
