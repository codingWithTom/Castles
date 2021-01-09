//
//  TurnPresenter.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-05.
//

import UIKit

final class TurnPresenter {
  static func turnViewModel(from turn: Turn) -> TurnViewModel {
    return TurnViewModel(isPlayerTurn: turn.isPlayer, color: turn.isPlayer ? .blue : .red)
  }
}

extension TurnViewModel {
  func view() -> UIView {
    let view = UIView()
    view.backgroundColor = isPlayerTurn ? .blue : .red
    view.layer.borderWidth = 1.0
    view.layer.borderColor = UIColor.black.cgColor
    return view
  }
}
