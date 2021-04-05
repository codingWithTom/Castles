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
    var perkService: PerkService = PerkServiceAdapter.shared
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
    print("Activated")
  }
  
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    updateKingdom(with: applicationContext)
    updatePerks(with: applicationContext)
  }
}

private extension StartPhoneSessionAdapter {
  func updateKingdom(with context: [String: Any]) {
    guard
      let kingdomDictionary = context[WatchConnectivityConstants.kingdom] as? [String: Any],
      let kingdomData = try? JSONSerialization.data(withJSONObject: kingdomDictionary, options: .fragmentsAllowed)
    else {
      print("Error retrieving kingdom from application context")
      return
    }
    do {
      let kingdom = try JSONDecoder().decode(Kingdom.self, from: kingdomData)
      dependencies.kingdomService.update(with: kingdom)
    } catch {
      print("Error decoding kingdom \(error)")
    }
  }
  
  func updatePerks(with context: [String: Any]) {
    guard
      let perksDictionaries = context[WatchConnectivityConstants.perks] as? [[String: Any]],
      let perksData = try? JSONSerialization.data(withJSONObject: perksDictionaries, options: .fragmentsAllowed)
    else {
      print("Error retrieving perks from application context")
      return
    }
    do {
      let perks = try JSONDecoder().decode([Perk].self, from: perksData)
      dependencies.perkService.update(perks)
    } catch {
      print("Error decoding perks \(error)")
    }
  }
}
