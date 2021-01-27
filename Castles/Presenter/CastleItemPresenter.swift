//
//  CastleItemPresenter.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-12.
//

import UIKit


final class CastleItemPresenter {
  func viewModel(for castleItem: CastleItem, shopItem: ShopItem) -> ShopItemViewModel {
    return castleItem.accept(visitor: self, data: shopItem)
  }
}

extension CastleItemPresenter: CastleItemVisitor {
  func visit(attackItem: AttackItem, data shopItem: ShopItem) -> ShopItemViewModel {
    return ShopItemViewModel(itemID: shopItem.itemID, name: shopItem.name, price: CurrencyPresenter.goldString(shopItem.price),
                             quantity: "\(shopItem.quantity)", imageName: "sword", isSystemImage: false, isAvailable: shopItem.quantity > 0)
  }
  
  func visit(defenseItem: DefenseItem, data shopItem: ShopItem) -> ShopItemViewModel {
    return ShopItemViewModel(itemID: shopItem.itemID, name: shopItem.name, price: CurrencyPresenter.goldString(shopItem.price),
                             quantity: "\(shopItem.quantity)", imageName: "shield", isSystemImage: false, isAvailable: shopItem.quantity > 0)
  }
  
  func visit(hpItem: HPItem, data shopItem: ShopItem) -> ShopItemViewModel {
    return ShopItemViewModel(itemID: shopItem.itemID, name: shopItem.name, price: CurrencyPresenter.goldString(shopItem.price),
                             quantity: "\(shopItem.quantity)", imageName: "suit.heart.fill", isSystemImage: true, isAvailable: shopItem.quantity > 0)
  }
}
