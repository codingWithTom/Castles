//
//  PerkService.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-07.
//

import Foundation
import Combine

protocol PerkService {
  var perkPublisher: AnyPublisher<[Perk], Never> { get }
  func use(perk: Perk)
}

final class PerkServiceAdapter: PerkService {
  static let shared = PerkServiceAdapter()
  
  var perkPublisher: AnyPublisher<[Perk], Never> {
    currentValuePerks.eraseToAnyPublisher()
  }
  private var currentValuePerks = CurrentValueSubject<[Perk], Never>([])
  private var perks: [Perk] = [] {
    didSet {
      saveData()
      currentValuePerks.value = perks
    }
  }
  private var fileURL: URL {
    let userDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return URL(fileURLWithPath: "perks", relativeTo: userDirectory)
  }
  
  private init() {
    retrieveData()
  }
  
  func use(perk: Perk) {
    guard let perkIndex = perks.firstIndex(where: { $0.id == perk.id }) else { return }
    var newPerk = perks[perkIndex]
    newPerk.lastUsedDate = Date()
    perks[perkIndex] = newPerk
  }
}

private extension PerkServiceAdapter {
  func retrieveData() {
    if let data = try? Data(contentsOf: fileURL), let perks = try? JSONDecoder().decode([Perk].self, from: data) {
      self.perks = perks
    } else {
      self.perks = [
        Perk(name: "Harvest", imageName: "plant", valueAdded: 300, type: .gold, cooldownTime: 20, lastUsedDate: Date()),
        Perk(name: "Smith", imageName: "anvil", valueAdded: 20, type: .attack, cooldownTime: 60, lastUsedDate: Date())
      ]
    }
  }
  
  func saveData() {
    do {
      let data = try JSONEncoder().encode(perks)
      try data.write(to: fileURL)
    } catch {
      print("Error saving perks: \(error)")
    }
  }
}
