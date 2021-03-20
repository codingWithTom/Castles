//
//  StartPhoneSession.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-03-20.
//

import Foundation
import WatchConnectivity

protocol StartPhoneSession {
  func execute()
}

final class StartPhoneSessionAdapter: NSObject, StartPhoneSession {
  struct Dependencies {
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
  }
  
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() {
    guard WCSession.isSupported() else { return }
    WCSession.default.delegate = self
    WCSession.default.activate()
  }
}

extension StartPhoneSessionAdapter: WCSessionDelegate {
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    // Do nothing
  }
  
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    guard
      let kingdomDictionary = applicationContext[WatchConnectivityConstants.context] as? [String: Any],
      let kingdomData = try? JSONSerialization.data(withJSONObject: kingdomDictionary, options: .fragmentsAllowed)
    else {
      print("Error retrieving application context")
      return
    }
    do {
      let kingdom = try JSONDecoder().decode(Kingdom.self, from: kingdomData)
      dependencies.kingdomService.update(with: kingdom)
    } catch {
      print("Error decoding kingdom \(error)")
    }
  }
}
