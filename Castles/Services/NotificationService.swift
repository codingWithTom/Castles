//
//  NotificationService.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-14.
//

import Foundation
import UserNotifications
import Combine

struct CastlesNotifications {
  static let usePerkActionIdentifier = "codingWithTom.Castles.perkActions.use"
  static let perkActionCategoryIdentifier = "codingWithTom.Castles.perkActions"
}

typealias PerkIdentifier = String

protocol NotificationService {
  var perkUseNotificationPublisher: AnyPublisher<PerkIdentifier, Never> { get }
  func scheduleNotification(for: Perk)
}

final class NotificationServiceAdapter: NSObject, NotificationService {
  static let shared = NotificationServiceAdapter()
  private var passthrough = PassthroughSubject<PerkIdentifier, Never>()
  var perkUseNotificationPublisher: AnyPublisher<PerkIdentifier, Never> {
    passthrough.eraseToAnyPublisher()
  }
  
  private override init() {
    super.init()
    UNUserNotificationCenter.current().delegate = self
    registerCategories()
  }
  
  func scheduleNotification(for perk: Perk) {
    UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
      if settings.authorizationStatus == .notDetermined {
        self?.requestNotificationPermission(for: perk)
      } else if settings.authorizationStatus == .denied {
        return
      } else {
        self?.scheduelLocalPerkNotification(perk)
      }
    }
  }
}

extension NotificationServiceAdapter: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    guard response.actionIdentifier == CastlesNotifications.usePerkActionIdentifier else {
      completionHandler()
      return
    }
    let perkIdentifier = response.notification.request.identifier
    passthrough.send(perkIdentifier)
    completionHandler()
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([])
  }
}

private extension NotificationServiceAdapter {
  func requestNotificationPermission(for perk: Perk) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { [weak self] success, error in
      guard success, error == nil else { return }
      self?.scheduleNotification(for: perk)
    }
  }
  
  func scheduelLocalPerkNotification(_ perk: Perk) {
    let content = UNMutableNotificationContent()
    content.title = "The \(perk.name) is ready!"
    content.body = "You perk is ready to be used."
    content.categoryIdentifier = CastlesNotifications.perkActionCategoryIdentifier
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: perk.cooldownTime, repeats: false)
    let request = UNNotificationRequest(identifier: perk.id.uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }
  
  func registerCategories() {
    let useAction = UNNotificationAction(identifier: CastlesNotifications.usePerkActionIdentifier, title: "Use Perk", options: .foreground)
    let category = UNNotificationCategory(identifier: CastlesNotifications.perkActionCategoryIdentifier,
                                          actions: [useAction], intentIdentifiers: [], options: [])
    UNUserNotificationCenter.current().setNotificationCategories([category])
  }
}
