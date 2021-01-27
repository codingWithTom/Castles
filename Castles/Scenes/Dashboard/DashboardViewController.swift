//
//  DashboardViewController.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-01.
//

import UIKit
import Combine

enum Section: Int, Hashable {
  case castles
  case actions
}

enum DashboardItem: Hashable {
  case castle(CastleViewModel)
  case action(ActionViewModel)
}

struct ActionViewModel: Hashable {
  let price: String
  let name: String
  let imageName: String
}

struct CastleViewModel: Hashable {
  let id: String
  let name: String
  let imageName: String
  let attack: String
  let defense: String
  let hp: String
}

struct TurnViewModel {
  let isPlayerTurn: Bool
  let color: UIColor
}

final class DashboardViewController: UIViewController {
  private enum DashboardState {
    case attacking
    case fortifying
    case waitingForBarbarian
    case waitingForPlayer
  }
  @IBOutlet private weak var castlesCollectionView: UICollectionView!
  @IBOutlet private weak var goldLabel: UILabel!
  @IBOutlet private weak var nextButtonView: UIView!
  @IBOutlet private weak var attackButtonView: UIView! {
    didSet {
      attackButtonView.layer.borderColor = UIColor.blue.cgColor
    }
  }
  @IBOutlet private weak var fortifyButtonView: UIView! {
    didSet {
      fortifyButtonView.layer.borderColor = UIColor.blue.cgColor
    }
  }
  @IBOutlet private weak var turnStackView: UIStackView!
  private var dataSource: UICollectionViewDiffableDataSource<Section, DashboardItem>?
  private var viewModel = DashboardViewModel()
  private var subscriptions = Set<AnyCancellable>()
  private var state: DashboardState = .waitingForPlayer {
    didSet {
      updateUI()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    observe()
  }
  
  @IBAction private func didTapShop(sender: Any?) {
    navigationController?.present(UINavigationController(rootViewController: ShopViewController()), animated: true, completion: nil)
  }
  
  @IBAction private func didTapNext(sender: Any?) {
    viewModel.userSelectedNextTurn()
  }
  
  @IBAction private func didTapAttack(sender: Any?) {
    state = .attacking
  }
  
  @IBAction private func didTapFortify(sender: Any?) {
    state = .fortifying
  }
}

extension DashboardViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if case .action = dataSource?.itemIdentifier(for: indexPath) {
      viewModel.userDidTapAddCastle()
    } else if case let .castle(castleViewModel) = dataSource?.itemIdentifier(for: indexPath) {
      let castleID = castleViewModel.id
      if state == .attacking {
        viewModel.userSelectedCastleForAttack(castleID: castleID)
      } else if state == .fortifying {
        viewModel.userSelectedCastleForFortification(castleID: castleID)
      } else {
        presentSelectCastleAlert()
      }
    }
  }
}

private extension DashboardViewController {
  func observe() {
    viewModel.$goldAmount.receive(on: RunLoop.main).sink { [weak self] in
      self?.goldLabel.text = $0
    }.store(in: &subscriptions)
    viewModel.$castles.receive(on: RunLoop.main).sink { [weak self] in
      self?.updateCastlesWith(viewModels: $0)
    }.store(in: &subscriptions)
    viewModel.$outcome.receive(on: RunLoop.main).sink { [weak self] in
      guard
        let outcome = $0,
        let outcomeScene = OutcomeViewController.outcomeScene(with: outcome)
      else { return }
      self?.present(outcomeScene, animated: true, completion: nil)
    }.store(in: &subscriptions)
    viewModel.$turns.receive(on: RunLoop.main).sink { [weak self] turns in
      guard !turns.isEmpty else { return }
      self?.updateStateWithTurn(turns[0])
      self?.fillTurnStack(with: turns)
    }.store(in: &subscriptions)
    viewModel.$errorMessage.receive(on: RunLoop.main).sink { [weak self] error in
      guard let castleError = error else { return }
      self?.presentErrorMessage(with: castleError)
    }.store(in: &subscriptions)
  }
  
  func configure() {
    configureCollectionView()
    configureDataSource()
  }
  
  func updateStateWithTurn(_ turn: TurnViewModel) {
    DispatchQueue.main.async {
      self.state = turn.isPlayerTurn ? .waitingForPlayer : .waitingForBarbarian
    }
  }
  
  func fillTurnStack(with turns: [TurnViewModel]) {
    DispatchQueue.main.async {
      self.turnStackView.subviews.forEach { $0.removeFromSuperview() }
      turns.forEach { self.turnStackView.addArrangedSubview($0.view()) }
    }
  }
  
  func updateUI() {
    self.nextButtonView.isHidden = state != .waitingForBarbarian
    self.attackButtonView.isHidden = state == .waitingForBarbarian
    self.attackButtonView.layer.borderWidth = state == .attacking ? 5.0 : 0.0
    self.fortifyButtonView.isHidden = state == .waitingForBarbarian
    self.fortifyButtonView.layer.borderWidth = state == .fortifying ? 5.0 : 0.0
  }
  
  func configureCollectionView() {
    let layout = UICollectionViewCompositionalLayout { section, environment in
      if environment.traitCollection.verticalSizeClass == .regular {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
      } else {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
      }
    }
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.scrollDirection = view.traitCollection.verticalSizeClass == .regular ? .vertical : .horizontal
    layout.configuration = configuration
    castlesCollectionView.collectionViewLayout = layout
    castlesCollectionView.backgroundColor = .clear
    castlesCollectionView.delegate = self
  }
  
  func configureDataSource() {
    let castleCellRegistration = UICollectionView.CellRegistration<CastleCollectionCell, CastleViewModel> { castleCell, indexPath, castleItem in
      castleCell.configure(with: castleItem)
    }
    
    let actionCellRegistration = UICollectionView.CellRegistration<ActionCollectionCell, ActionViewModel> { actionCell, indexPath, actionItem in
      actionCell.configure(with: actionItem)
    }
    dataSource = UICollectionViewDiffableDataSource<Section, DashboardItem>(collectionView: castlesCollectionView) { collectionView, indexPath, item in
      switch item {
      case let .castle(castleViewModel):
        return collectionView.dequeueConfiguredReusableCell(using: castleCellRegistration, for: indexPath, item: castleViewModel)
      case let .action(actionViewModel):
        return collectionView.dequeueConfiguredReusableCell(using: actionCellRegistration, for: indexPath, item: actionViewModel)
      }
    }
    dataSource?.apply(NSDiffableDataSourceSectionSnapshot<DashboardItem>(), to: .castles)
    var addCastleSectionSnapshot = NSDiffableDataSourceSectionSnapshot<DashboardItem>()
    addCastleSectionSnapshot.append([DashboardItem.action(ActionViewModel(price: "1,000", name: "Add Castle", imageName: "plus.circle"))])
    dataSource?.apply(addCastleSectionSnapshot, to: .actions)
  }
  
  func updateCastlesWith(viewModels: [CastleViewModel]) {
    var addCastleSectionSnapshot = NSDiffableDataSourceSectionSnapshot<DashboardItem>()
    addCastleSectionSnapshot.append(viewModels.map { DashboardItem.castle($0) })
    dataSource?.apply(addCastleSectionSnapshot, to: .castles)
  }
  
  func presentSelectCastleAlert() {
    let message = state == .waitingForPlayer ? "Select an action before selecting a castle" : "Can't do an action with a castle this turn"
    let alertController = UIAlertController(title: "Select a Castle", message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
  
  func presentErrorMessage(with error: ErrorViewModel) {
    let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
}
