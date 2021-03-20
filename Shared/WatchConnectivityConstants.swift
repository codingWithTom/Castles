//
//  WatchConnectivityConstants.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-03-20.
//

import Foundation

struct WatchConnectivityConstants {
  enum PlayerAction: String {
    case attack
    case fortify
  }
  
  static let context = "com.codingWithTom.Castles.watchContext"
  static let castleID = "com.codingWithTom.Castles.castleID"
  static let action = "com.codingWithTom.Castles.action"
}
