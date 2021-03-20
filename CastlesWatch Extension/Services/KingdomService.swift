//
//  KingdomService.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-03-16.
//

import Foundation
import Combine

protocol KingdomService {
  var goldPublisher: AnyPublisher<Int, Never> { get }
  var castlePublisher: AnyPublisher<[Castle], Never> { get }
  func update(with: Kingdom)
}

final class KingdomServiceAdapter: KingdomService {
  static let shared = KingdomServiceAdapter()
  
  private var currentValueGold = CurrentValueSubject<Int, Never>(0)
  private var currentValueCastles = CurrentValueSubject<[Castle], Never>([])
  
  var goldPublisher: AnyPublisher<Int, Never> {
    currentValueGold.eraseToAnyPublisher()
  }
  
  var castlePublisher: AnyPublisher<[Castle], Never> {
    currentValueCastles.eraseToAnyPublisher()
  }
  
  private init() { }
  
  func update(with kingdom: Kingdom) {
    currentValueGold.send(kingdom.gold)
    currentValueCastles.send(kingdom.castles)
  }
}
