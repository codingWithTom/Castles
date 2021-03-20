//
//  StartWatchSession.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-03-20.
//

import Foundation
import WatchConnectivity

protocol StartWatchSession {
  func execute()
}

final class StartWatchSessionAdapter: NSObject, StartWatchSession {
  struct Dependencies {
    var performPlayerTurn: PerformPlayerTurn = PerformPlayerTurnAdapter()
    var turnService: TurnService = TurnServiceAdapter.shared
    var syncWatchContext: SyncWatchContext = SyncWatchContextAdapter()
  }
  
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() {
    guard WCSession.isSupported() else { return }
    WCSession.default.delegate = self
    WCSession.default.activate()
  }
}

extension StartWatchSessionAdapter: WCSessionDelegate {
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    dependencies.syncWatchContext.execute()
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) { }
  
  func sessionDidDeactivate(_ session: WCSession) { }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    guard
      dependencies.turnService.isPlayerTurn(),
      let action = message[WatchConnectivityConstants.action] as? String,
      let playerAction = WatchConnectivityConstants.PlayerAction(rawValue: action),
      let castleID = message[WatchConnectivityConstants.castleID] as? String
    else { return }
    switch playerAction {
    case .attack:
      dependencies.performPlayerTurn.executeAttack(castleID: castleID)
    case .fortify:
      dependencies.performPlayerTurn.executeFortify(castleID: castleID)
    }
  }
}
