//
//  GetGoldPublisher.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-03-14.
//

import Foundation
import Combine

protocol GetGoldPublisher {
  func execute() -> AnyPublisher<Int, Never>
}

final class GetGoldPublisherAdapter: GetGoldPublisher {
  struct Dependencies {
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
  }
  
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> AnyPublisher<Int, Never> {
    dependencies.kingdomService.goldPublisher
  }
}
