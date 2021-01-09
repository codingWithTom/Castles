//
//  Outcome.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-31.
//

import Foundation

enum Outcome {
  case fortify(castle: Castle, defenseIncrease: Int, attackIncrease: Int, hpIncrease: Int)
  case plunder(castle: Castle, defenseDecrease: Int, hpDecrease: Int, isCastleDestroyed: Bool)
  case attack(castle: Castle, attackDecrease: Int, loot: Int)
}

