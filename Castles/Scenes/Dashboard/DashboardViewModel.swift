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
    var getPerksPublisher: GetPerksPublisher = GetPerksPublisherAdapter()
    var usePerk: UsePerk = UsePerkAdapter()
  }
  private let dependencies: Dependencies
  @Published var goldAmount: String = "0"
  @Published var castles: [CastleViewModel] = []
  @Published var actions: [ActionViewModel] = []
  @Published var outcome: Outcome?
  @Published var turns: [TurnViewModel] = []
  @Published var errorMessage: ErrorViewModel?
  private var perks: [Perk] = []
  private var subscriptions = Set<AnyCancellable>()
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    observe()
  }
  
  
  func userSelectedAction(withIndex index: Int) {
    if index == 0 {
      userDidTapAddCastle()
    } else {
      let perk = perks[index - 1]
      dependencies.usePerk.execute(perk: perk)
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
    dependencies.getGoldPublisher.execute().sink { [weak self] in
      self?.goldAmount = CurrencyPresenter.goldString($0)
    }.store(in: &subscriptions)
    dependencies.getCastlePublisher.execute().sink { [weak self] castles in
      self?.castles = castles.map { CastlePresenter.castleViewModel(from: $0) }
    }.store(in: &subscriptions)
    dependencies.getTurnPublisher.execute().sink { [weak self] turns in
      self?.turns = turns.map { TurnPresenter.turnViewModel(from: $0) }
    }.store(in: &subscriptions)
    dependencies.getOutcomePublisher.execute().sink { [weak self] in
      self?.outcome = $0
    }.store(in: &subscriptions)
    dependencies.getPerksPublisher.execute().sink { [weak self] in
      self?.perks = $0
      let addCastleAction = ActionViewModel(id: "Add Castle Cell", value: "-1,000", name: "Add Castle", imageName: "plus.circle",
                                            isImageIcon: true, valueImageName: "gold", startDate: nil, endDate: nil)
      self?.actions = [addCastleAction] +
        $0.map { perk in PerkPresenter.viewModel(for: perk) }
        
    }.store(in: &subscriptions)
  }
  
  func userDidTapAddCastle() {
    let outcome = dependencies.createCastle.execute()
    if case let .failure(error) = outcome {
      errorMessage = ErrorPresenter.viewModel(from: error)
    }
  }
}
