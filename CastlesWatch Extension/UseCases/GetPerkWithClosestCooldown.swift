//
//  GetPerkWithClosestCooldown.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-04-04.
//

import Foundation

protocol GetPerkWithClosestCooldown {
  func execute() -> Perk?
}

final class GetPerkWithClosestCooldownAdapter: GetPerkWithClosestCooldown {
  struct Dependencies {
    var perkService: PerkService = PerkServiceAdapter.shared
  }
  
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> Perk? {
    return dependencies.perkService.getPerks()
      .filter { $0.remainingCooldownTime > 0 }
      .min { $0.remainingCooldownTime < $1.remainingCooldownTime }
  }
}
