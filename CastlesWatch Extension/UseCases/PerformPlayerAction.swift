//
//  PerformPlayerAction.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-03-14.
//

import Foundation
import WatchConnectivity

protocol PerformPlayerAction {
  func executeAttack(castleID: String)
  func executeFortify(castleID: String)
}

final class PerformPlayerActionAdapter: PerformPlayerAction {
  
  func executeAttack(castleID: String) {
    sendAction(.attack, for: castleID)
  }
  
  func executeFortify(castleID: String) {
    sendAction(.fortify, for: castleID)
  }
}

private extension PerformPlayerActionAdapter {
  func sendAction(_ action: WatchConnectivityConstants.PlayerAction, for castleID: String) {
    guard WCSession.default.isReachable else { return }
    let message: [String: Any] = [WatchConnectivityConstants.action: action.rawValue, WatchConnectivityConstants.castleID: castleID]
    WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
  }
}
