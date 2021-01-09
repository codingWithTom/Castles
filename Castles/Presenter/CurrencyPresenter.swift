//
//  CurrencyPresenter.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-01.
//

import UIKit

final class CurrencyPresenter {
  static func goldString(_ gold: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 0
    return numberFormatter.string(from: NSNumber(value: gold)) ?? "0"
  }
}
