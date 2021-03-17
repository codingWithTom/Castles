//
//  PerformPlayerAction.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-03-14.
//

import Foundation

protocol PerformPlayerAction {
  func executeAttack(castleID: String)
  func executeFortify(castleID: String)
}

final class PerformPlayerActionAdapter: PerformPlayerAction {
  
  func executeAttack(castleID: String) {
    print("Attacking with \(castleID)")
  }
  
  func executeFortify(castleID: String) {
    print("Fortifying with \(castleID)")
  }
}
