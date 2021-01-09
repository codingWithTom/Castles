//
//  PerformBarbarianTurn.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-31.
//

import Foundation

protocol PerformBarbarianTurn {
  func execute()
}

final class PerformBarbarianTurnAdapter: PerformBarbarianTurn {
  struct Dependencies {
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
    var outcomeService: OutcomeService = OutcomeServiceAdapter.shared
    var turnService: TurnService = TurnServiceAdapter.shared
    var shopService: ShopService = ShopServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() {
    guard let castleToAttack = dependencies.kingdomService.getCastles().randomElement() else { return }
    let attackedCastle = dependencies.outcomeService.plunderCastle(castleToAttack)
    dependencies.kingdomService.updateCastle(attackedCastle)
    dependencies.turnService.popTurn()
    dependencies.shopService.refreshStore()
  }
}
