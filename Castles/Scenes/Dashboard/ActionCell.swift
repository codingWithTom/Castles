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
  private var actionImageView = UIImageView()
  private var titleLabel = UILabel()
  private var priceLabel = UILabel()
  private var priceImageView = UIImageView()
  private var blockProgressView = BlockedProgressView()
  private var lastActionCheckedProgressFor: String?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    lastActionCheckedProgressFor = nil
  }
  
  override func updateConfiguration(using state: UICellConfigurationState) {
    if contentView.subviews.isEmpty { configureView() }
    guard let viewModel = state.viewModel else { return }
    titleLabel.text = viewModel.name
    actionImageView.image = viewModel.isImageIcon ? UIImage(systemName: viewModel.imageName) : UIImage(named: viewModel.imageName)
    priceLabel.text = viewModel.value
    priceImageView.image = UIImage(named: viewModel.valueImageName)
    
    guard lastActionCheckedProgressFor == nil else { return }
    lastActionCheckedProgressFor = viewModel.id
    if let startDate = viewModel.startDate, let endDate = viewModel.endDate, endDate.timeIntervalSinceNow > 0 {
      isUserInteractionEnabled = false
      blockProgressView.setupProgressWith(startDate: startDate, endDate: endDate) { [weak self] in
        self?.isUserInteractionEnabled = true
        self?.lastActionCheckedProgressFor = nil
      }
    } else {
      isUserInteractionEnabled = true
    }
  }
}

private extension ActionCollectionCell {
  func configureView() {
    actionImageView.contentMode = .scaleAspectFit
    actionImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
    actionImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    contentView.addSubview(stackView)
    stackView.axis = .vertical
    stackView.addArrangedSubview(actionImageView)
    titleLabel.textAlignment = .center
    titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
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
    contentView.addSubview(blockProgressView)
    blockProgressView.frame = contentView.bounds
    blockProgressView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
