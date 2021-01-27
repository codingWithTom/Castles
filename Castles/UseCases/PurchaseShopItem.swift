//
//  PurchaseShopItem.swift
//  Castles
//
//  Created by Tomas Trujillo on 2020-12-31.
//

import Foundation

protocol PurchaseShopItem {
  func execute(item: ShopItem) -> Result<Void, CastlesError>
}

final class PurchaseShopItemAdapter: PurchaseShopItem {
  struct Dependencies {
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
    var shopService: ShopService = ShopServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute(item: ShopItem) -> Result<Void, CastlesError> {
    do {
      try dependencies.kingdomService.modifyGoldWith(quantity: -item.price)
      dependencies.shopService.decreaseQuantity(for: item)
      return .success(())
    } catch {
      return .failure(error as? CastlesError ?? .unknown)
    }
  }
}
