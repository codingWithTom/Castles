//
//  DashboardView.swift
//  CastlesWatch Extension
//
//  Created by Tomas Trujillo on 2021-03-13.
//

import SwiftUI

struct CastleViewModel {
  let name: String
  let attack: String
  let defense: String
}

struct DashboardView: View {
  
  @ObservedObject var viewModel: DashboardViewModel
  @State private var isShowingSheet: Bool = false
  
  var body: some View {
    VStack {
      HStack {
        Image("Gold")
          .resizable()
          .frame(width: 30, height: 30)
        Text("$\(viewModel.gold)")
      }
      List(viewModel.castles.indices, id: \.self) { index in
        let castle = viewModel.castles[index]
        castleRow(from: castle)
          .onTapGesture {
            viewModel.selectedCastle(at: index)
            isShowingSheet = true
          }
      }
    }
    .actionSheet(isPresented: $isShowingSheet) {
      ActionSheet(title: Text("Select an action"), message: Text("Attack or Fortify"),
                  buttons: [
                    ActionSheet.Button.default(Text("Attack"), action: { viewModel.selectedAttack() }),
                    ActionSheet.Button.default(Text("Fortify"), action: { viewModel.selectedFortify() })
                  ])
    }
  }
  
  @ViewBuilder
  func castleRow(from castle: CastleViewModel) -> some View {
    VStack(alignment: .leading) {
      Text(castle.name)
      HStack {
        HStack {
          Image("Sword")
            .resizable()
            .frame(width: 30, height: 30)
          Text(castle.attack)
        }
        Spacer()
        HStack {
          Image("Shield")
            .resizable()
            .frame(width: 30, height: 30)
          Text(castle.defense)
        }
      }
    }
  }
}

struct DashboardView_Previews: PreviewProvider {
  static var previews: some View {
    DashboardView(viewModel: DashboardViewModel())
  }
}
