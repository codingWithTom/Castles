//
//  DashboardViewModel.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-03-13.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
  struct Dependencies {
    var getCastlesPublisher: GetCastlesPublisher = GetCastlesPublisherAdapter()
    var getGoldPublisher: GetGoldPublisher = GetGoldPublisherAdapter()
    var performPlayerAction: PerformPlayerAction = PerformPlayerActionAdapter()
  }
  
  @Published var gold: String = CurrencyPresenter.goldString(0)
  @Published var castles: [CastleViewModel] = []
  @Published var selectedCastleID: String?
  
  private let dependencies: Dependencies
  private var playerCastles: [Castle] = [] {
    didSet {
      castles = playerCastles.map {
        CastleViewModel(name: $0.name, attack: "\($0.attackPower)", defense: "\($0.defensePower)", hp: $0.hp)
      }
    }
  }
  private var subscriptions = Set<AnyCancellable>()
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    listen()
  }
  
  func selectedAttack() {
    guard let castleID = selectedCastleID else { return }
    dependencies.performPlayerAction.executeAttack(castleID: castleID)
  }
  
  func selectedFortify() {
    guard let castleID = selectedCastleID else { return }
    dependencies.performPlayerAction.executeFortify(castleID: castleID)
  }
  
  func selectedCastle(at index: Int) {
    selectedCastleID = playerCastles[index].castleID
  }
}

private extension DashboardViewModel {
  func listen() {
    dependencies.getGoldPublisher.execute().receive(on: RunLoop.main).sink { [weak self] in
      self?.gold = CurrencyPresenter.goldString($0)
    }.store(in: &subscriptions)
    dependencies.getCastlesPublisher.execute().receive(on: RunLoop.main).sink { [weak self] in
      self?.playerCastles = $0
    }.store(in: &subscriptions)
  }
}
