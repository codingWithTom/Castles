//
//  PerksService.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-04-04.
//

import Foundation
import ClockKit

protocol PerkService {
  func getPerks() -> [Perk]
  func update(_: [Perk])
}

final class PerkServiceAdapter: PerkService {
  static var shared = PerkServiceAdapter()
  
  private var perks: [Perk] = [] {
    didSet {
      updateComplications()
    }
  }
  
  private init() {}
  
  func getPerks() -> [Perk] {
    return perks
  }
  
  func update(_ perks: [Perk]) {
    self.perks = perks
  }
}

private extension PerkServiceAdapter {
  func updateComplications() {
    let server = CLKComplicationServer.sharedInstance()
    for complication in server.activeComplications ?? [] {
      guard case .graphicRectangular = complication.family else { continue }
      server.reloadTimeline(for: complication)
    }
  }
}
