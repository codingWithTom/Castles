//
//  CastleComplicationProvider.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-04-04.
//

import Foundation
import ClockKit
import SwiftUI

final class CastleComplicationProvider {
  struct Dependencies {
    var getCastleWithLowestHP: GetCastleWithLowestHP = GetCastleWithLowestHPAdapter()
  }
  
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func getComplication() -> CLKComplicationTemplate {
    if let castle = dependencies.getCastleWithLowestHP.execute() {
      let viewModel = CastleViewModel(name: castle.name, attack: "\(castle.attackPower)", defense: "\(castle.defensePower)", hp: castle.hp)
      return CLKComplicationTemplateGraphicExtraLargeCircularView(
        CastleComplication(viewModel: viewModel)
      )
    } else {
      return getSample()
    }
  }
  
  func getSample() -> CLKComplicationTemplate {
    let castleView = CastleComplication(viewModel:
      CastleViewModel(name: "Swift Castle", attack: "80",
                      defense: "100", hp: 60)
    )
    return CLKComplicationTemplateGraphicExtraLargeCircularView(castleView)
  }
}
