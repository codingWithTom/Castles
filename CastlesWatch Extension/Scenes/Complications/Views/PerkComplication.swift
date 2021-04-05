//
//  PerkComplication.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-04-04.
//

import SwiftUI
import ClockKit

struct PerkViewModel {
  let imageName: String
  let name: String
  let cooldownTime: Double
  let remainingTime: Double
}

struct PerkComplication: View {
  @Environment(\.complicationRenderingMode) var renderingMode

  let viewModel: PerkViewModel
  
  var body: some View {
    VStack {
      summary
      
      progress
    }
  }
  
  private var summary: some View {
    HStack {
      Image(viewModel.imageName)
        .resizable()
        .frame(width: 40, height: 20)
      Text(viewModel.name)
      Spacer()
    }
  }
  
  private var progress: some View {
    ProgressView(value: viewModel.remainingTime, total: viewModel.cooldownTime)
  }
}

struct PerkComplication_Previews: PreviewProvider {
  static var previews: some View {
    let view = PerkComplication(viewModel: PerkViewModel(
      imageName: "anvil",
      name: "Smith",
      cooldownTime: 20,
      remainingTime: 10
    ))
    
    Group {
      view
      CLKComplicationTemplateGraphicRectangularFullView(
        view
      ).previewContext()
    }
  }
}
