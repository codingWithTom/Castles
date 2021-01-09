//
//  OutcomeService.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-31.
//

import Foundation
import Combine

protocol OutcomeService {
  var outcomePublisher: AnyPublisher<Outcome, Never> { get }
  func plunderCastle(_: Castle) -> Castle
  func attackWithCastle(_: Castle) -> (castle: Castle, goldIncrease: Int)
  func fortifyCastle(_: Castle) -> Castle
}

final class OutcomeServiceAdapter: OutcomeService {
  static let shared = OutcomeServiceAdapter()
  private let defenseDecreasePercentage = 0.5
  private let hpDamageDecrease = 0.6
  private let minAttackLost = 0.3
  private let lootMultiplier = 10
  private let minLootPercent = 0.6
  private let fortifyHPRecovery = 50
  private let fortifyDefenseRecoveryRange = (50 ... 90)
  private let fortifyAttackRecoveryRange = (30 ... 60)
  private var passthroughOutcome = PassthroughSubject<Outcome, Never>()
  var outcomePublisher: AnyPublisher<Outcome, Never> { passthroughOutcome.eraseToAnyPublisher() }
  
  private init() { }
  
  func plunderCastle(_ castle: Castle) -> Castle {
    var plunderedCastle = castle
    let raidPower = Double.random(in: 0 ... 100)
    let defenseDecrease = Int(raidPower * defenseDecreasePercentage)
    let hpDecrease = max(Int(raidPower) - Int(Double(plunderedCastle.defensePower) * hpDamageDecrease), 0)
    plunderedCastle.defensePower = max(0, plunderedCastle.defensePower - defenseDecrease)
    plunderedCastle.decreaseHP(hpDecrease)
    let outcome = Outcome.plunder(castle: plunderedCastle, defenseDecrease: defenseDecrease, hpDecrease: abs(hpDecrease), isCastleDestroyed: plunderedCastle.hp <= 0)
    broadcast(outcome: outcome)
    return plunderedCastle
  }
  
  func attackWithCastle(_ castle: Castle) -> (castle: Castle, goldIncrease: Int) {
    var attackingCastle = castle
    let lowerAttackRange = Int(Double(attackingCastle.attackPower) * minAttackLost)
    let attackLost = Int.random(in: lowerAttackRange ... attackingCastle.attackPower)
    attackingCastle.attackPower -= attackLost
    let maxLoot = attackingCastle.attackPower * lootMultiplier
    let loot = Int(Double(maxLoot) * Double.random(in: minLootPercent ... 1.0))
    let outcome = Outcome.attack(castle: attackingCastle, attackDecrease: attackLost, loot: loot)
    broadcast(outcome: outcome)
    return (castle: attackingCastle, goldIncrease: loot)
  }
  
  func fortifyCastle(_ castle: Castle) -> Castle {
    var fortifiedCastle = castle
    let defenseIncrease = Int.random(in: fortifyDefenseRecoveryRange)
    let attackIncrease = Int.random(in: fortifyAttackRecoveryRange)
    let previousHP = fortifiedCastle.hp
    fortifiedCastle.increaseHP(fortifyHPRecovery)
    fortifiedCastle.attackPower += attackIncrease
    fortifiedCastle.defensePower += defenseIncrease
    let hpIncrease = fortifiedCastle.hp - previousHP
    let outcome = Outcome.fortify(castle: fortifiedCastle, defenseIncrease: defenseIncrease, attackIncrease: attackIncrease, hpIncrease: hpIncrease)
    broadcast(outcome: outcome)
    return fortifiedCastle
  }
}

private extension OutcomeServiceAdapter {
  func broadcast(outcome: Outcome) {
    passthroughOutcome.send(outcome)
  }
}
