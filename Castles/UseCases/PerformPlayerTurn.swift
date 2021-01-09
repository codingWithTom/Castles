//
//  PerformPlayerTurn.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-31.
//

import Foundation

protocol PerformPlayerTurn {
  func executeAttack(castleID: String)
  func executeFortify(castleID: String)
}

final class PerformPlayerTurnAdapter: PerformPlayerTurn {
  struct Dependencies {
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
    var outcomeService: OutcomeService = OutcomeServiceAdapter.shared
    var shopService: ShopService = ShopServiceAdapter.shared
    var turnService: TurnService = TurnServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func executeAttack(castleID: String) {
    guard let castle = dependencies.kingdomService.getCastle(withID: castleID) else { return }
    let (castleAfterAttack, loot) = dependencies.outcomeService.attackWithCastle(castle)
    dependencies.kingdomService.modifyGoldWith(quantity: loot)
    dependencies.kingdomService.updateCastle(castleAfterAttack)
    dependencies.shopService.refreshStore()
    dependencies.turnService.popTurn()
  }
  
  func executeFortify(castleID: String) {
    guard let castle = dependencies.kingdomService.getCastle(withID: castleID) else { return }
    let castleAfterFortify = dependencies.outcomeService.fortifyCastle(castle)
    dependencies.kingdomService.updateCastle(castleAfterFortify)
    dependencies.shopService.refreshStore()
    dependencies.turnService.popTurn()
  }
}
