//
//  KingdomService.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-03-16.
//

import Foundation
import Combine
import ClockKit

protocol KingdomService {
  var goldPublisher: AnyPublisher<Int, Never> { get }
  var castlePublisher: AnyPublisher<[Castle], Never> { get }
  func update(with: Kingdom)
  func getCastles() -> [Castle]
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
  
  func getCastles() -> [Castle] {
    return currentValueCastles.value
  }
  
  func update(with kingdom: Kingdom) {
    currentValueGold.send(kingdom.gold)
    currentValueCastles.send(kingdom.castles)
    let server = CLKComplicationServer.sharedInstance()
    for complication in server.activeComplications ?? [] {
      guard case .graphicExtraLarge = complication.family else { continue }
      server.reloadTimeline(for: complication)
    }
  }
}
