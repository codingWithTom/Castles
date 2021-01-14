//
//  ShopViewController.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-12.
//

import UIKit
import Combine

final class ShopViewController: UIViewController {
  
  private var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<String, ShopItemViewModel>?
  private var shopItemSubscriber: AnyCancellable?
  private var viewModel = ShopViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    configureCollection()
    observe()
  }
  
  @objc
  func didTapCancel() {
    dismiss(animated: true, completion: nil)
  }
}

extension ShopViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard
      let item = dataSource?.itemIdentifier(for: indexPath),
      viewModel.isItemIDForCastle(item.itemID),
      let cell = collectionView.cellForItem(at: indexPath)
    else { return }
    presentSheet(forItemID: item.itemID, inCell: cell)
  }
}

private extension ShopViewController {
  func configureView() {
    let layout = UICollectionViewCompositionalLayout { section, environment in
      let percentageOfHeight: CGFloat = environment.traitCollection.verticalSizeClass == .regular ? 0.25 : 0.5
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(percentageOfHeight))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      return NSCollectionLayoutSection(group: group)
    }
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    collectionView.backgroundColor = .systemBackground
    collectionView.delegate = self
    view.addSubview(collectionView)
    title = "Shop"
    let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
    navigationItem.leftBarButtonItem = cancelBarButton
  }
  
  func configureCollection() {
    let cellRegistration = UICollectionView.CellRegistration<ShopCellCollectionView, ShopItemViewModel> {cell, _, shopItemViewModel in
      cell.configure(with: shopItemViewModel)
    }
    
    dataSource = UICollectionViewDiffableDataSource<String, ShopItemViewModel>(collectionView: collectionView) { collectionView, indexPath, shopItemViewModel in
      return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: shopItemViewModel)
    }
  }
  
  func updateDataSource(with items: [ShopItemViewModel]) {
    var snapshot = NSDiffableDataSourceSectionSnapshot<ShopItemViewModel>()
    snapshot.append(items)
    dataSource?.apply(snapshot, to: "")
  }
  
  func observe() {
    shopItemSubscriber = viewModel.$items.receive(on: RunLoop.main).sink { [weak self] in
      self?.updateDataSource(with: $0)
    }
  }
  
  func presentSheet(forItemID itemID: String, inCell cell: UICollectionViewCell) {
    let sheetController = UIAlertController(title: "Apply Item to Castle",
                                            message: "To which castle shall the item be applied to?",
                                            preferredStyle: .actionSheet)
    let names = viewModel.castleNames
    names.enumerated().forEach { index, name in
      sheetController.addAction(UIAlertAction(title: name, style: .default) { [weak self] _ in
        self?.viewModel.selectedCastleIndex(index, for: itemID)
      })
    }
    sheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    sheetController.popoverPresentationController?.sourceView = cell
    sheetController.popoverPresentationController?.sourceRect = cell.bounds
    present(sheetController, animated: true, completion: nil)
  }
}
