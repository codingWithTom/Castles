//
//  GetOutcomePublisher.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-31.
//

import Foundation
import Combine

protocol GetOutcomePublisher {
  func execute() -> AnyPublisher<Outcome, Never>
}

final class GetOutcomePublisherAdapter: GetOutcomePublisher {
  struct Dependencies {
    var outcomeService: OutcomeService = OutcomeServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> AnyPublisher<Outcome, Never> {
    return dependencies.outcomeService.outcomePublisher
  }
}
