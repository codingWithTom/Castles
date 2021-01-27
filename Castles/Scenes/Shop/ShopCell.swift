//
//  ShopCell.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-12.
//

import UIKit

private extension UIConfigurationStateCustomKey {
  static let viewModel = UIConfigurationStateCustomKey("com.codingWithTom.castles.shopCell.viewModell")
}

private extension UIConfigurationState {
  var viewModel: ShopItemViewModel? {
    get { self[.viewModel] as? ShopItemViewModel }
    set { self[.viewModel] = newValue }
  }
}

class ShopCell: UICollectionViewCell {
  private var viewModel: ShopItemViewModel?
  
  func configure(with viewModel: ShopItemViewModel) {
    self.viewModel = viewModel
    setNeedsUpdateConfiguration()
  }
  
  override var configurationState: UICellConfigurationState {
    var state = super.configurationState
    state.viewModel = viewModel
    return state
  }
}

final class ShopCellCollectionView: ShopCell {
  private var priceLabel = UILabel()
  private var itemImageView = UIImageView()
  private var nameLabel = UILabel()
  private var quantityLabel = UILabel()
  private var blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
  
  override func updateConfiguration(using state: UICellConfigurationState) {
    if contentView.subviews.isEmpty { configureView() }
    guard let viewModel = state.viewModel else { return }
    priceLabel.text = "$\(viewModel.price)"
    itemImageView.image = viewModel.isSystemImage ? UIImage(systemName: viewModel.imageName) : UIImage(named: viewModel.imageName)
    if viewModel.isSystemImage {
      itemImageView.tintColor = .red
    }
    nameLabel.text = viewModel.name
    quantityLabel.text = viewModel.quantity
    if viewModel.isAvailable {
      enableCell()
    } else {
      disableCell()
    }
  }
}

private extension ShopCellCollectionView {
  func configureView() {
    quantityLabel.backgroundColor = .blue
    quantityLabel.textColor = .white
    quantityLabel.layer.cornerRadius = 4.0
    itemImageView.contentMode = .scaleAspectFit
    itemImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    itemImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    itemImageView.addSubview(blurEffect)
    blurEffect.frame = itemImageView.bounds
    itemImageView.addSubview(blurEffect)
    blurEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    priceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    contentView.addSubview(itemImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(priceLabel)
    contentView.addSubview(quantityLabel)
    itemImageView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    quantityLabel.translatesAutoresizingMaskIntoConstraints = false
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      itemImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 8.0),
      nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      priceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0),
      priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
      quantityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0)
    ])
  }
  
  func disableCell() {
    isUserInteractionEnabled = false
    blurEffect.isHidden = false
  }
  
  func enableCell() {
    isUserInteractionEnabled = true
    blurEffect.isHidden = true
  }
}
