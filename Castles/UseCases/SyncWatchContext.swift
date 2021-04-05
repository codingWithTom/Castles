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
    var perkService: PerkService = PerkServiceAdapter.shared
  }
  
  private let dependencies: Dependencies
  private var subscriptions = Set<AnyCancellable>()
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() {
    dependencies.kingdomService.kingdomPublisher.sink { [weak self] _ in
      self?.updateContext()
    }.store(in: &subscriptions)
    dependencies.perkService.perkPublisher.sink { [weak self] _ in
      self?.updateContext()
    }.store(in: &subscriptions)
  }
}

private extension SyncWatchContextAdapter {
  func updateContext() {
    guard WCSession.default.isReachable else { return }
    do {
      try WCSession.default.updateApplicationContext(
        [
          WatchConnectivityConstants.kingdom: getKindomContext(),
          WatchConnectivityConstants.perks: getPerksContext()
        ])
    } catch {
      print("Error sending application context")
    }
  }
  
  func getKindomContext() -> [String: Any] {
    guard
      let kingdomData = try? JSONEncoder().encode(dependencies.kingdomService.getKingdom()),
      let kingdomDictionary = try? JSONSerialization.jsonObject(with: kingdomData, options: .allowFragments) as? [String: Any]
    else {
      print("Error updating kingdom context")
      return [:]
    }
    return kingdomDictionary
  }
  
  func getPerksContext() -> [[String: Any]] {
    guard
      let perkData = try? JSONEncoder().encode(dependencies.perkService.getPerks()),
      let perkDictionary = try? JSONSerialization.jsonObject(with: perkData, options: .allowFragments) as? [[String: Any]]
    else {
      print("Error updating perk context")
      return [[:]]
    }
    return perkDictionary
  }
}
