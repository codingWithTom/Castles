//
//  SchedulePerkNotification.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-14.
//

import Foundation

protocol SchedulePerkNotification {
  func execute(perk: Perk)
}

final class SchedulePerkNotificationAdapter: SchedulePerkNotification {
  struct Dependencies {
    var notificationService: NotificationService = NotificationServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute(perk: Perk) {
    dependencies.notificationService.scheduleNotification(for: perk)
  }
}
