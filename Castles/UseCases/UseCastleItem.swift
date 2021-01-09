//
//  UseCastleItem.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-31.
//

import Foundation

protocol UseCastleItem {
  func execute(item: CastleItem, castle: Castle)
}

final class UseCastleItemAdapter: UseCastleItem {
  struct Dependencies {
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute(item: CastleItem, castle: Castle) {
    let newCastle = item.accept(visitor: self, data: castle)
    dependencies.kingdomService.updateCastle(newCastle)
  }
}

extension UseCastleItemAdapter: CastleItemVisitor {
  func visit(attackItem: AttackItem, data castle: Castle) -> Castle {
    var modifiedCastle = castle
    modifiedCastle.attackPower += attackItem.attackIncrease
    return modifiedCastle
  }
  
  func visit(hpItem: HPItem, data castle: Castle) -> Castle {
    var modifiedCastle = castle
    modifiedCastle.increaseHP(hpItem.hpIncrease)
    return modifiedCastle
  }
  
  func visit(defenseItem: DefenseItem, data castle: Castle) -> Castle {
    var modifiedCastle = castle
    modifiedCastle.defensePower += defenseItem.defenseIncrease
    return modifiedCastle
  }
}
