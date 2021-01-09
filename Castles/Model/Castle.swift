//
//  Castle.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-28.
//

import Foundation

struct Castle: Codable {
  let castleID: String
  let imageName: String
  let name: String
  private(set) var hp: Int = 100
  var attackPower: Int = 100
  var defensePower: Int = 100
  
  mutating func increaseHP(_ increase: Int) {
    hp = min(100, hp + increase)
  }
  
  mutating func decreaseHP(_ decrease: Int) {
    hp = max(0, hp - decrease)
  }
}
