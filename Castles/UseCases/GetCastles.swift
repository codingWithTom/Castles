//
//  GetCastles.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-12.
//

import Foundation

protocol GetCastles {
  func execute() -> [Castle]
}

final class GetCastlesAdapter: GetCastles {
  struct Dependencies {
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> [Castle] {
    return dependencies.kingdomService.getCastles()
  }
}
