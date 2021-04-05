//
//  ShortcutComplication.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-04-04.
//

import SwiftUI
import ClockKit

struct ShortcutComplication: View {
    var body: some View {
      VStack {
        Image(systemName: "gamecontroller")
        Text("Play")
          .font(.footnote)
      }
    }
}

struct ShortcutComplication_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        ShortcutComplication()
        CLKComplicationTemplateGraphicCornerCircularView(
          ShortcutComplication()
        ).previewContext()
      }
    }
}
