//
//  TurnService.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-31.
//

import Foundation
import Combine

protocol TurnService {
  var turnPublisher: AnyPublisher<[Turn], Never> { get }
  func popTurn()
}

final class TurnServiceAdapter: TurnService {
  static let shared = TurnServiceAdapter()
  
  private var fileURL: URL {
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return URL(fileURLWithPath: "turns", relativeTo: directory)
  }
  private var turns: [Turn] = [] {
    didSet {
      currentValueTurns.value = turns
    }
  }
  private var currentValueTurns = CurrentValueSubject<[Turn], Never>([])
  var turnPublisher: AnyPublisher<[Turn], Never> { currentValueTurns.eraseToAnyPublisher() }
  
  private init() {
    retrieveData()
  }
  
  func popTurn() {
    var newTurns = turns
    newTurns.removeFirst()
    newTurns.append(getNextTurn())
    self.turns = newTurns
  }
}

private extension TurnServiceAdapter {
  func retrieveData() {
    if let data = try? Data(contentsOf: fileURL),
       let turns = try? JSONDecoder().decode([Turn].self, from: data) {
      self.turns = turns
    } else {
      createGame()
    }
  }
  
  func saveData() {
    do {
      let data = try JSONEncoder().encode(turns)
      try data.write(to: fileURL)
    } catch {
      print("Error saving ")
    }
  }
  
  func getNextTurn() -> Turn {
    let nextTurnValue = Double.random(in: 0 ... 1)
    let isPlayer = nextTurnValue <= 0.5
    return Turn(isPlayer: isPlayer)
  }
  
  func createGame() {
    let turns = (0 ..< 5).map { _ in getNextTurn() }
    self.turns = turns
    saveData()
  }
}
