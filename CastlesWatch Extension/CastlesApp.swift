//
//  CastlesApp.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-03-13.
//

import SwiftUI

@main
struct CastlesApp: App {
  @StateObject var viewModel = CastlesAppViewModel()
  
  @SceneBuilder var body: some Scene {
    WindowGroup {
      NavigationView {
        DashboardView(viewModel: DashboardViewModel())
      }
    }
    
    WKNotificationScene(controller: NotificationController.self, category: "myCategory")
  }
}
