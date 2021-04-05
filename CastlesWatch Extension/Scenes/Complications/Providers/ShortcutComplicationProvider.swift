//
//  ShortcutComplicationProvider.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-04-04.
//

import Foundation
import ClockKit
import SwiftUI

final class ShortcutComplicationProvider {
  func getShortcutComplication() -> CLKComplicationTemplate {
    return CLKComplicationTemplateGraphicCornerCircularView(ShortcutComplication())
  }
}

