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
}
