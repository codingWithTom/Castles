//
//  CastleCell.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-03.
//

import UIKit
import SpriteKit

private extension UIConfigurationStateCustomKey {
  static let viewModel = UIConfigurationStateCustomKey(rawValue: "com.codingWithTom.castles.castleCell.viewModel")
}

private extension UIConfigurationState {
  var viewModel: CastleViewModel? {
    get { self[.viewModel] as? CastleViewModel }
    set { self[.viewModel] = newValue }
  }
}

class CastleCell: UICollectionViewCell {
  var viewModel: CastleViewModel?
  
  func configure(with viewModel: CastleViewModel) {
    self.viewModel = viewModel
  }
  
  override var configurationState: UICellConfigurationState {
    var state = super.configurationState
    state.viewModel = viewModel
    return state
  }
}

final class CastleCollectionCell: CastleCell {
  struct Dependencies {
    var castleEffect: CastleEffect = CastleEffectAdapter()
  }
  private var castleStackView = UIStackView()
  private var castleImageView = UIImageView()
  private var attackImageView = UIImageView()
  private var attackLabel = UILabel()
  private var defenseImageView = UIImageView()
  private var defenseLabel = UILabel()
  private var hpImageView = UIImageView()
  private var hpLabel = UILabel()
  private var nameLabel = UILabel()
  private var castleScene = SKView()
  var dependencies: Dependencies = .init()
  
  override func updateConfiguration(using state: UICellConfigurationState) {
    if contentView.subviews.isEmpty { configureView() }
    guard let viewModel = state.viewModel else { return }
    nameLabel.text = viewModel.name
    attackLabel.text = viewModel.attack
    defenseLabel.text = viewModel.defense
    hpLabel.text = viewModel.hp
    castleImageView.image = UIImage(named: viewModel.imageName)
    addEffect(for: viewModel)
  }
}

private extension CastleCollectionCell {
  func configureView() {
    castleStackView.axis = .vertical
    castleStackView.addArrangedSubview(castleImageView)
    castleStackView.addArrangedSubview(nameLabel)
    castleImageView.contentMode = .scaleAspectFit
    castleImageView.addSubview(castleScene)
    castleScene.frame = castleImageView.bounds
    castleScene.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    castleScene.backgroundColor = .clear
    
    nameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
    nameLabel.textAlignment = .center
    nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    castleImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    attackImageView.image = UIImage(named: "sword_side")
    attackImageView.contentMode = .scaleAspectFit
    defenseImageView.image = UIImage(named: "shield")
    defenseImageView.contentMode = .scaleAspectFit
    hpImageView.image = UIImage(systemName: "suit.heart.fill")
    hpImageView.tintColor = UIColor.systemRed
    hpImageView.contentMode = .scaleAspectFit
    contentView.addSubview(castleStackView)
    contentView.addSubview(attackImageView)
    contentView.addSubview(attackLabel)
    contentView.addSubview(defenseImageView)
    contentView.addSubview(defenseLabel)
    contentView.addSubview(hpImageView)
    contentView.addSubview(hpLabel)
    castleStackView.translatesAutoresizingMaskIntoConstraints = false
    attackImageView.translatesAutoresizingMaskIntoConstraints = false
    attackLabel.translatesAutoresizingMaskIntoConstraints = false
    defenseImageView.translatesAutoresizingMaskIntoConstraints = false
    defenseLabel.translatesAutoresizingMaskIntoConstraints = false
    hpImageView.translatesAutoresizingMaskIntoConstraints = false
    hpLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      castleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      castleStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      castleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      castleStackView.bottomAnchor.constraint(equalTo: attackImageView.topAnchor),
      attackImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1),
      attackImageView.widthAnchor.constraint(equalTo: attackImageView.heightAnchor, multiplier: 3 / 2),
      attackLabel.leadingAnchor.constraint(equalTo: attackImageView.trailingAnchor),
      attackLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
      attackLabel.centerYAnchor.constraint(equalTo: attackImageView.centerYAnchor),
      defenseImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1),
      defenseImageView.widthAnchor.constraint(equalTo: defenseImageView.heightAnchor, multiplier: 3 / 2),
      defenseImageView.centerYAnchor.constraint(equalTo: attackImageView.centerYAnchor),
      defenseImageView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
      defenseLabel.leadingAnchor.constraint(equalTo: defenseImageView.trailingAnchor),
      defenseLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      defenseLabel.centerYAnchor.constraint(equalTo: defenseImageView.centerYAnchor),
      hpImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1),
      hpImageView.widthAnchor.constraint(equalTo: hpImageView.heightAnchor, multiplier: 3 / 2),
      hpImageView.topAnchor.constraint(equalTo: attackImageView.bottomAnchor, constant: 8.0),
      hpImageView.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
      hpImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      hpLabel.leadingAnchor.constraint(equalTo: hpImageView.trailingAnchor),
      hpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      hpLabel.centerYAnchor.constraint(equalTo: hpImageView.centerYAnchor),
    ])
  }
  
  func addEffect(for viewModel: CastleViewModel) {
    guard let effect = dependencies.castleEffect.getEffectFor(condition: viewModel.condition) else {
      castleScene.isHidden = true
      return
    }
    let scene = SKScene(size: castleScene.bounds.size)
    scene.addChild(effect)
    scene.backgroundColor = .clear
    scene.anchorPoint = CGPoint(x: 0.5, y: 0.2)
    castleScene.isHidden = false
    castleScene.presentScene(scene)
  }
}
