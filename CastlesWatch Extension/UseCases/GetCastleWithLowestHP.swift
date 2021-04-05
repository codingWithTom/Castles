//
//  GetCastleWithLowestHP.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-04-04.
//

import Foundation

protocol GetCastleWithLowestHP {
  func execute() -> Castle?
}

final class GetCastleWithLowestHPAdapter: GetCastleWithLowestHP {
  struct Dependencies {
    var kingdomSevice: KingdomService = KingdomServiceAdapter.shared
  }
  
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> Castle? {
    return dependencies.kingdomSevice.getCastles().min { $0.hp < $1.hp }
  }
}
