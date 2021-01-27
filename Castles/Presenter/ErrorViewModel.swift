//
//  ErrorViewModel.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-26.
//

import Foundation

struct ErrorViewModel {
  let title: String
  let message: String
}

final class ErrorPresenter {
  static func viewModel(from error: CastlesError) -> ErrorViewModel {
    switch error {
    case .insufficientGold:
      return ErrorViewModel(title: "Insufficient Gold", message: "We are sorry, you don't have enough gold to buy this. Loot more before coming back!")
    case .unknown:
      return ErrorViewModel(title: "Unknown Error", message: "Unfortunately we don't know what happen. Please try again.")
    }
  }
}
