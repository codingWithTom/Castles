//
//  SyncPerkNotifications.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-14.
//

import Foundation
import Combine

protocol SyncPerkNotifications {
  func execute()
}

final class SyncPerkNotificationsAdapter: SyncPerkNotifications {
  struct Dependencies {
    var getPerkActions: GetPerkNotificationActionPublisher = GetPerkNotificationActionPublisherAdapter()
    var perkService: PerkService = PerkServiceAdapter.shared
    var usePerk: UsePerk = UsePerkAdapter()
  }
  private let dependencies: Dependencies
  private var subscriptions = Set<AnyCancellable>()
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() {
    dependencies.getPerkActions.execute().sink { [weak self] perkIdentifier in
      guard let self = self else { return }
      let perks = self.dependencies.perkService.getPerks()
      guard let index = perks.firstIndex(where: { $0.id.uuidString == perkIdentifier }) else { return }
      self.dependencies.usePerk.execute(perk: perks[index])
    }.store(in: &subscriptions)
  }
}
