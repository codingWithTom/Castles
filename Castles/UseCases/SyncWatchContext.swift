//
//  SyncWatchContext.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-03-20.
//

import Foundation
import Combine
import WatchConnectivity

protocol SyncWatchContext {
  func execute()
}

final class SyncWatchContextAdapter: SyncWatchContext {
  struct Dependencies {
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
  }
  
  private let dependencies: Dependencies
  private var subscriptions = Set<AnyCancellable>()
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() {
    dependencies.kingdomService.kingdomPublisher.sink { [weak self] kingdom in
      self?.updateContextWith(kingdom)
    }.store(in: &subscriptions)
  }
}

private extension SyncWatchContextAdapter {
  func updateContextWith(_ kingdom: Kingdom) {
    guard WCSession.default.isReachable else { return }
    guard
      let kingdomData = try? JSONEncoder().encode(kingdom),
      let kingdomDictionary = try? JSONSerialization.jsonObject(with: kingdomData, options: .allowFragments) as? [String: Any]
    else {
      print("Error updating application context")
      return
    }
    do {
      try WCSession.default.updateApplicationContext([WatchConnectivityConstants.context: kingdomDictionary])
    } catch {
      print("Error sending application context")
    }
  }
}
