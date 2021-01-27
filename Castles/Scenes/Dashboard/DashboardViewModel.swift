//
//  DashboardViewModel.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-01.
//

import Foundation
import Combine

final class DashboardViewModel {
  struct Dependencies {
    var getCastlePublisher: GetCastlesPublisher = GetCastlesPublisherAdapter()
    var getGoldPublisher: GetGoldPublisher = GetGoldPublisherAdapter()
    var getOutcomePublisher: GetOutcomePublisher = GetOutcomePublisherAdapter()
    var getTurnPublisher: GetTurnPublisher = GetTurnPublisherAdapter()
    var createCastle: CreateCastle = CreateCastleAdapter()
    var performPlayerTurn: PerformPlayerTurn = PerformPlayerTurnAdapter()
    var performBarbarianTurn: PerformBarbarianTurn = PerformBarbarianTurnAdapter()
  }
  private let dependencies: Dependencies
  @Published var goldAmount: String = "0"
  @Published var castles: [CastleViewModel] = []
  @Published var outcome: Outcome?
  @Published var turns: [TurnViewModel] = []
  @Published var errorMessage: ErrorViewModel?
  private var goldSubscriber: AnyCancellable?
  private var castlesSubscriber: AnyCancellable?
  private var turnSubscriber: AnyCancellable?
  private var outcomeSubscirber: AnyCancellable?
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    observe()
  }
  
  func userDidTapAddCastle() {
    let outcome = dependencies.createCastle.execute()
    if case let .failure(error) = outcome {
      errorMessage = ErrorPresenter.viewModel(from: error)
    }
  }
  
  func userSelectedCastleForAttack(castleID: String) {
    dependencies.performPlayerTurn.executeAttack(castleID: castleID)
  }
  
  func userSelectedCastleForFortification(castleID: String) {
    dependencies.performPlayerTurn.executeFortify(castleID: castleID)
  }
  
  func userSelectedNextTurn() {
    dependencies.performBarbarianTurn.execute()
  }
}

private extension DashboardViewModel {
  func observe() {
    goldSubscriber = dependencies.getGoldPublisher.execute().sink { [weak self] in
      self?.goldAmount = CurrencyPresenter.goldString($0)
    }
    castlesSubscriber = dependencies.getCastlePublisher.execute().sink { [weak self] castles in
      self?.castles = castles.map { CastlePresenter.castleViewModel(from: $0) }
    }
    turnSubscriber = dependencies.getTurnPublisher.execute().sink { [weak self] turns in
      self?.turns = turns.map { TurnPresenter.turnViewModel(from: $0) }
    }
    outcomeSubscirber = dependencies.getOutcomePublisher.execute().sink { [weak self] in
      self?.outcome = $0
      
    }
  }
}
