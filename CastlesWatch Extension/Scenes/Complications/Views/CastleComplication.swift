//
//  CastleComplication.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-04-04.
//

import SwiftUI
import ClockKit

struct CastleComplication: View {
  let viewModel: CastleViewModel
  var body: some View {
    VStack {
      HStack {
        Gauge(value: Double(viewModel.hp), in: 0 ... 100, label: {
          Image(systemName: "heart.fill")
        })
        .gaugeStyle(CircularGaugeStyle(tint:
                                        Gradient(colors: [.red, .yellow, .white])
        ))
        
        Spacer()
        
        VStack {
          Text(viewModel.name)
            .font(.footnote)
          HStack {
            Image("Sword")
              .resizable()
              .frame(width: 20, height: 20)
            Text(viewModel.attack)
              .font(.footnote)
          }
        }
      }
    }
    .padding(.horizontal)
  }
}

struct CastleComplication_Previews: PreviewProvider {
  static var previews: some View {
    let view = CastleComplication(viewModel:
      CastleViewModel(name: "Swift Castle", attack: "80",
                      defense: "100", hp: 60)
    )
    Group {
      view
      CLKComplicationTemplateGraphicExtraLargeCircularView(
        view
      ).previewContext()
    }
  }
}
