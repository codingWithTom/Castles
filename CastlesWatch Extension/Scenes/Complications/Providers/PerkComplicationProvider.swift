//
//  PerkComplicationProvider.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-04-04.
//

import Foundation
import ClockKit
import SwiftUI

final class PerkComplicationProvider {
  struct Dependencies {
    var getPerkWithClosestCooldown: GetPerkWithClosestCooldown = GetPerkWithClosestCooldownAdapter()
  }
  
  private let dependencies: Dependencies
  var perkEndDate: Date? { perkInComplication?.cooldownDate }
  private var perkInComplication: Perk?
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func getComplication() -> CLKComplicationTemplate {
    if let perk = dependencies.getPerkWithClosestCooldown.execute() {
      let viewModel = PerkViewModel(imageName: perk.imageName, name: perk.name,
                                    cooldownTime: perk.cooldownTime, remainingTime: perk.passedCooldownTime)
      perkInComplication = perk
      return CLKComplicationTemplateGraphicRectangularFullView(PerkComplication(viewModel: viewModel))
    } else {
      perkInComplication = nil
      return getSample()
    }
  }
  
  func getSample() -> CLKComplicationTemplate {
    let sampleViewModel = PerkViewModel(
      imageName: "anvil",
      name: "Smith",
      cooldownTime: 20, remainingTime: 10)
    return CLKComplicationTemplateGraphicRectangularFullView(
      PerkComplication(viewModel: sampleViewModel)
    )
  }
  
  func getFutureEntries(after from: Date, limit: Int) -> [CLKComplicationTimelineEntry]? {
    guard let perk = perkInComplication, from < perk.cooldownDate else { return nil }
    let until = perk.cooldownDate
    let time = until.timeIntervalSince(from)
    let jumps = time / Double(limit)
    let viewModels = (0 ..< limit).map {
      PerkViewModel(imageName: perk.imageName, name: perk.name,
                    cooldownTime: perk.cooldownTime, remainingTime: perk.passedCooldownTime + jumps * Double($0))
    }
    return viewModels.enumerated().map { (index, viewModel) in
      CLKComplicationTimelineEntry(date: Date().addingTimeInterval(jumps * Double(index)),
                                   complicationTemplate: CLKComplicationTemplateGraphicRectangularFullView(PerkComplication(viewModel: viewModel)))
    }
  }
}
