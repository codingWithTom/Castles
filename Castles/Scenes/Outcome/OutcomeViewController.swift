//
//  OutcomeViewController.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-05.
//

import UIKit

class OutcomeViewController: UIViewController {
  
  static func outcomeScene(with outcome: Outcome) -> UIViewController? {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard
      let navigation = storyboard.instantiateViewController(identifier: "OutcomeScene") as? UINavigationController,
      let outcomeController = navigation.viewControllers.first as? OutcomeViewController
    else { return nil }
    outcomeController.configureView(with: outcome)
    return navigation
  }
  
  private var viewModel: OutcomeViewModel?
  @IBOutlet private weak var entriesStack: UIStackView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  func configureView(with outcome: Outcome) {
    self.viewModel = OutcomeViewModel(outcome: outcome)
  }
  
  @IBAction private func didTapCancel() {
    self.dismiss(animated: true, completion: nil)
  }
}

private extension OutcomeViewController {
  func updateUI() {
    let entries = viewModel?.getEntries() ?? []
    DispatchQueue.main.async {
      self.title = self.viewModel?.title
      self.updateViewWithEntries(entries)
    }
  }
  
  func updateViewWithEntries(_ entries: [OutcomeEntryType]) {
    entriesStack.subviews.forEach { $0.removeFromSuperview() }
    entries.forEach { entriesStack.addArrangedSubview(entryView(from: $0)) }
  }
  
  func entryView(from entry: OutcomeEntryType) -> UIView {
    switch entry {
    case let .affectedCastle(imageName: castleImageName, name: castleName):
      return stackForTuple(text: castleName, imageName: castleImageName, isIcon: false)
    case let .attackChange(value: change):
      return stackForTuple(text: change, imageName: "sword_side", isIcon: false)
    case let .defeneseChange(value: change):
      return stackForTuple(text: change, imageName: "shield", isIcon: false)
    case let .hpChange(value: change):
      return stackForTuple(text: change, imageName: "suit.heart.fill", isIcon: true)
    case let .loot(value: change):
      return stackForTuple(text: change, imageName: "gold", isIcon: false)
    case let .castleDestroyed(text: castleName):
      let label = UILabel()
      label.font = UIFont.preferredFont(forTextStyle: .title3)
      label.text = castleName
      return label
    }
  }
  
  func stackForTuple(text: String, imageName: String, isIcon: Bool) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 10
    let label = UILabel()
    label.text = text
    let imageView = UIImageView()
    imageView.image = isIcon ? UIImage(systemName: imageName) : UIImage(named: imageName)
    imageView.contentMode = .scaleAspectFit
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(label)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    label.translatesAutoresizingMaskIntoConstraints = false
    imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
      imageView.heightAnchor.constraint(equalTo: label.heightAnchor, multiplier: 2.5)
    ])
    return stackView
  }
}
