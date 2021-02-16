//
//  GetPerkNotificationActionPublisher.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-14.
//

import Foundation
import Combine

protocol GetPerkNotificationActionPublisher {
  func execute() -> AnyPublisher<PerkIdentifier, Never>
}

final class GetPerkNotificationActionPublisherAdapter: GetPerkNotificationActionPublisher {
  struct Dependencies {
    var notificationService: NotificationService = NotificationServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> AnyPublisher<PerkIdentifier, Never> {
    return dependencies.notificationService.perkUseNotificationPublisher
  }
}
