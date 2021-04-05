//
//  Perk.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-07.
//

import Foundation

enum PerkType: Int, Codable {
  case gold
  case attack
}

struct Perk: Codable {
  var id = UUID()
  let name: String
  let imageName: String
  let valueAdded: Int
  let type: PerkType
  let cooldownTime: Double //Seconds
  var lastUsedDate: Date
  
  var isCooldownPassed: Bool {
    let endDate = lastUsedDate.addingTimeInterval(cooldownTime)
    return Date() > endDate
  }
  
  var cooldownDate: Date {
    return lastUsedDate.addingTimeInterval(cooldownTime)
  }
  
  var passedCooldownTime: Double {
    lastUsedDate.timeIntervalSinceNow * -1
  }
  
  var remainingCooldownTime: Double {
    max(cooldownDate.timeIntervalSince(Date()), 0)
  }
}
