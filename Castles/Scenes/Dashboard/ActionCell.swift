//
//  ActionCell.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-01.
//

import UIKit

private extension UIConfigurationStateCustomKey {
  static let viewModel = UIConfigurationStateCustomKey(rawValue: "com.codignWithTom.castles.addActionCell.viewModel")
}

private extension UIConfigurationState {
  var viewModel: ActionViewModel? {
    get { self[.viewModel] as? ActionViewModel }
    set { self[.viewModel] = newValue }
  }
}

class ActionCell: UICollectionViewCell {
  var viewModel: ActionViewModel?
  
  func configure(with viewModel: ActionViewModel) {
    self.viewModel = viewModel
    setNeedsUpdateConfiguration()
  }
  
  override var configurationState: UICellConfigurationState {
    var state = super.configurationState
    state.viewModel = viewModel
    return state
  }
}

final class ActionCollectionCell: ActionCell {
  private var stackView = UIStackView()
  private var iconImageView = UIImageView()
  private var titleLabel = UILabel()
  private var priceLabel = UILabel()
  private var priceImageView = UIImageView()
  
  override func updateConfiguration(using state: UICellConfigurationState) {
    if contentView.subviews.isEmpty { configureView() }
    guard let viewModel = state.viewModel else { return }
    titleLabel.text = viewModel.name
    iconImageView.image = UIImage(systemName: viewModel.imageName)
    priceLabel.text = viewModel.price
  }
}

private extension ActionCollectionCell {
  func configureView() {
    iconImageView.contentMode = .scaleAspectFit
    contentView.addSubview(stackView)
    stackView.axis = .vertical
    stackView.addArrangedSubview(iconImageView)
    titleLabel.textAlignment = .center
    stackView.addArrangedSubview(titleLabel)
    priceImageView.image = UIImage(named: "gold")
    priceImageView.contentMode = .scaleAspectFit
    priceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    priceLabel.textAlignment = .right
    priceImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    contentView.addSubview(priceImageView)
    contentView.addSubview(priceLabel)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    priceImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      stackView.bottomAnchor.constraint(equalTo: priceImageView.topAnchor),
      priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      priceLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
      priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      priceImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
      priceImageView.widthAnchor.constraint(equalTo: priceImageView.heightAnchor, multiplier: 3 / 2),
      priceImageView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8),
      priceImageView.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor)
    ])
  }
}
