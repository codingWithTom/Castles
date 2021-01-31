//
//  CastlePresenter.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-01.
//

import UIKit

final class CastlePresenter {
  static func castleViewModel(from castle: Castle) -> CastleViewModel {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 0
    return CastleViewModel(
      id: castle.castleID,
      name: castle.name,
      imageName: castle.imageName,
      attack: numberFormatter.string(from: NSNumber(value: castle.attackPower)) ?? "0",
      defense: numberFormatter.string(from: NSNumber(value: castle.defensePower)) ?? "0",
      hp: numberFormatter.string(from: NSNumber(value: castle.hp)) ?? "0",
      condition: condition(for: castle)
    )
  }
  
  private static func condition(for castle: Castle) -> CastleViewModel.Condition {
    if castle.hp == 100 {
      return .perfect
    } else if castle.hp <= 30 {
      return .onFire
    }
    return .normal
  }
}
