//
//  ShopViewModel.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-12.
//

import Foundation
import Combine

struct ShopItemViewModel: Hashable {
  let itemID: String
  let name: String
  let price: String
  let quantity: String
  let imageName: String
  let isSystemImage: Bool
}

final class ShopViewModel {
  struct Dependencies {
    var getShopItemPublisher: GetshopItemPublisher = GetShopItemPublisherAdapter()
    var useCastleItem: UseCastleItem = UseCastleItemAdapter()
    var getCastles: GetCastles = GetCastlesAdapter()
    var purchaseShopItem: PurchaseShopItem = PurchaseShopItemAdapter()
  }
  private let dependencies: Dependencies
  private var itemSubscriber: AnyCancellable?
  private var shopItems: [ShopItem] = [] {
    didSet {
      let presenter = ShopItemPresenter()
      items = shopItems.map { presenter.viewModel(for: $0) }
    }
  }
  @Published var items: [ShopItemViewModel] = []
  var castleNames: [String] {
    return dependencies.getCastles.execute().map { $0.name }
  }
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    observe()
  }
  
  func isItemIDForCastle(_ itemID: String) -> Bool {
    guard let item = shopItems.first(where: { $0.itemID == itemID }) else { return false }
    return item.wrappedItem is CastleItem
  }
  
  func selectedCastleIndex(_ index: Int, for itemID: String) {
    guard
      let item = shopItems.first(where: { $0.itemID == itemID }),
      let castleItem = item.wrappedItem as? CastleItem
    else { return }
    let castle = dependencies.getCastles.execute()[index]
    dependencies.purchaseShopItem.execute(item: item)
    dependencies.useCastleItem.execute(item: castleItem, castle: castle)
  }
}

private extension ShopViewModel {
  func observe() {
    itemSubscriber = dependencies.getShopItemPublisher.execute().sink { [weak self] in
      self?.shopItems = $0
    }
  }
}
