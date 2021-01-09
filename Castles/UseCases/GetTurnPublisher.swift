//
//  GetTurnPublisher.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-01.
//

import Foundation
import Combine

protocol GetTurnPublisher {
  func execute() -> AnyPublisher<[Turn], Never>
}

final class GetTurnPublisherAdapter: GetTurnPublisher {
  struct Dependencies {
    var turnService: TurnService = TurnServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> AnyPublisher<[Turn], Never> {
    return dependencies.turnService.turnPublisher
  }
}
