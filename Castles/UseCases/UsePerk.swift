//
//  UsePerk.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-07.
//

import Foundation

protocol UsePerk {
  func execute(perk: Perk)
}

final class UsePerkAdapter: UsePerk {
  struct Dependencies {
    var perkService: PerkService = PerkServiceAdapter.shared
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
    var outcomeService: OutcomeService = OutcomeServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute(perk: Perk) {
    dependencies.perkService.use(perk: perk)
    switch perk.type {
    case .gold:
      useGoldPerk(perk)
    case .attack:
      useAttackPerk(perk)
    }
  }
}

private extension UsePerkAdapter {
  func useGoldPerk(_ perk: Perk) {
    do {
      try dependencies.kingdomService.modifyGoldWith(quantity: perk.valueAdded)
      dependencies.outcomeService.applyPerkOutcome(.goldPerkUsed(goldIncrease: perk.valueAdded))
    } catch {
      print("Error increasing gold: \(error)")
    }
  }
  
  func useAttackPerk(_ perk: Perk) {
    guard var castle = dependencies.kingdomService.getCastles().randomElement() else { return }
    castle.attackPower += perk.valueAdded
    dependencies.kingdomService.updateCastle(castle)
    dependencies.outcomeService.applyPerkOutcome(.attackPerkUsed(castle: castle, attackIncrease: perk.valueAdded))
  }
}
