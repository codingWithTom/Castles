//
//  KingdomService.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-28.
//

import Foundation
import Combine

protocol KingdomService {
  var castlesPublisher: AnyPublisher<[Castle], Never> { get }
  var goldPublisher: AnyPublisher<Int, Never> { get }
  func getCastles() -> [Castle]
  func getCastle(withID: String) -> Castle?
  func getCurrentGold() -> Int
  func updateCastle(_: Castle)
  func createCastle(withName: String, imageName: String)
  func modifyGoldWith(quantity: Int) throws
}

final class KingdomServiceAdapter: KingdomService {
  static let shared = KingdomServiceAdapter()
  private var fileURL: URL {
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return URL(fileURLWithPath: "castles", relativeTo: directory)
  }
  private var kingdom: Kingdom = .new {
    didSet {
      castleCurrentValue.value = kingdom.castles
      goldCurrentValue.value = kingdom.gold
      saveData()
    }
  }
  private var castleCurrentValue = CurrentValueSubject<[Castle], Never>([])
  private var goldCurrentValue = CurrentValueSubject<Int, Never>(0)
  var castlesPublisher: AnyPublisher<[Castle], Never> { castleCurrentValue.eraseToAnyPublisher() }
  var goldPublisher: AnyPublisher<Int, Never> { goldCurrentValue.eraseToAnyPublisher() }
  
  private init() {
    self.retrieveData()
  }
  
  func getCastles() -> [Castle] {
    return kingdom.castles
  }
  
  func getCastle(withID castleID: String) -> Castle? {
    return kingdom.castles.first { $0.castleID == castleID }
  }
  
  func getCurrentGold() -> Int {
    return kingdom.gold
  }
  
  func updateCastle(_ castle: Castle) {
    guard let index = kingdom.castles.firstIndex(where: { $0.castleID == castle.castleID }) else { return }
    if castle.hp == 0 {
      kingdom.castles.remove(at: index)
    } else {
      kingdom.castles[index] = castle
    }
  }
  
  func createCastle(withName name: String, imageName: String) {
    let newCastle = Castle(castleID: UUID().uuidString, imageName: imageName, name: name)
    kingdom.castles.insert(newCastle, at: 0)
  }
  
  func modifyGoldWith(quantity: Int) throws {
    if kingdom.gold + quantity < 0 {
      throw CastlesError.insufficientGold
    }
    kingdom.gold += quantity
  }
}

private extension KingdomServiceAdapter {
  func saveData() {
    do {
      let data = try JSONEncoder().encode(kingdom)
      try data.write(to: fileURL)
    } catch {
      print("Error saving file: \(error)")
    }
  }
  
  func retrieveData() {
    if let data = try? Data(contentsOf: fileURL), let kingdom = try? JSONDecoder().decode(Kingdom.self, from: data) {
      self.kingdom = kingdom
    } else {
      self.kingdom = .new
      saveData()
    }
  }
}
