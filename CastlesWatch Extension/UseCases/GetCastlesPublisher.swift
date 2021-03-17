//
//  GetCastlesPublisher.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-03-14.
//

import Foundation
import Combine

protocol GetCastlesPublisher {
  func execute() -> AnyPublisher<[Castle], Never>
}

final class GetCastlesPublisherAdapter: GetCastlesPublisher {
  struct Dependencies {
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
  }
  
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> AnyPublisher<[Castle], Never> {
    dependencies.kingdomService.castlePublisher
  }
}
