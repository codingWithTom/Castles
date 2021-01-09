//
//  Kingdom.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-28.
//

import Foundation

struct Kingdom: Codable {
  static let newCastlePrice = 1000
  
  var castles: [Castle]
  var gold: Int
}

extension Kingdom {
  static var new: Kingdom {
    Kingdom(castles: [Castle(castleID: UUID().uuidString, imageName: "castle1", name: "Swift Stronghold")], gold: 1000)
  }
}
