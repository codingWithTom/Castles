//
//  PerkPresenter.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-08.
//

import Foundation

final class PerkPresenter {
  static func viewModel(for perk: Perk) -> ActionViewModel {
    var startDate: Date?
    var endDate: Date?
    if Date().timeIntervalSince(perk.lastUsedDate.addingTimeInterval(perk.cooldownTime)) < 0 {
      startDate = perk.lastUsedDate
      endDate = perk.lastUsedDate.addingTimeInterval(perk.cooldownTime)
    }
    switch perk.type {
    case .attack:
      return ActionViewModel(id: perk.id.uuidString, value: "\(perk.valueAdded)", name: perk.name, imageName: perk.imageName,
                             isImageIcon: false, valueImageName: "sword_side", startDate: startDate, endDate: endDate)
    case .gold:
      return ActionViewModel(id: perk.id.uuidString, value: "+ \(perk.valueAdded)", name: perk.name, imageName: perk.imageName,
                             isImageIcon: false, valueImageName: "gold", startDate: startDate, endDate: endDate)
    }
  }
}
