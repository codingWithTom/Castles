//
//  SlideInViewController.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-22.
//

import UIKit

final class SlideInViewController: UIViewController {
  
  private var slideTransitioningDelegate: SlideInTransitioningDelegate?
  private var controller: UIViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
  }
  
  func slideIn(viewController: UIViewController, in presentingController: UIViewController) {
    let transitionDelegate = SlideInTransitioningDelegate(viewWidth: view.bounds.width)
    self.slideTransitioningDelegate = transitionDelegate
    self.modalPresentationStyle = .custom
    self.transitioningDelegate = slideTransitioningDelegate
    addController(viewController)
    presentingController.present(self, animated: true, completion: nil)
  }
}

private extension SlideInViewController {
  func addGesture(to view: UIView) {
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
  }
  
  @objc
  func didTapView() {
    dismiss(animated: true, completion: nil)
    controller = nil
  }
  
  func addController(_ viewController: UIViewController) {
    controller = viewController
    let backgroundView = UIView()
    backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    addGesture(to: backgroundView)
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    viewController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(viewController.view)
    view.addSubview(backgroundView)
    NSLayoutConstraint.activate([
      viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
      viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      viewController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
      backgroundView.leadingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}

fileprivate final class SlideInTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  let viewWidth: CGFloat
  
  init(viewWidth: CGFloat) {
    self.viewWidth = viewWidth
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideInAnimatedTransitioninig(viewWidth: viewWidth, isDismissing: false)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideInAnimatedTransitioninig(viewWidth: viewWidth, isDismissing: true)
  }
}

fileprivate final class SlideInAnimatedTransitioninig: NSObject, UIViewControllerAnimatedTransitioning {
  let viewWidth: CGFloat
  let isDismissing: Bool
  
  init(viewWidth: CGFloat, isDismissing: Bool) {
    self.viewWidth = viewWidth
    self.isDismissing = isDismissing
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    isDismissing ? dismissingTransition(using: transitionContext) : presentingTransition(using: transitionContext)
  }
  
  private func presentingTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let destinationView = transitionContext.view(forKey: .to) else { return }
    destinationView.transform = .init(translationX: -viewWidth, y: 0.0)
    transitionContext.containerView.addSubview(destinationView)
    UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
      destinationView.transform = .identity
    } completion: { transitionContext.completeTransition($0) }
  }
  
  private func dismissingTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let destinationView = transitionContext.view(forKey: .from) else { return }
    destinationView.transform = .identity
    transitionContext.containerView.addSubview(destinationView)
    UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
      destinationView.transform = .init(translationX: -self.viewWidth, y: 0.0)
    } completion: { transitionContext.completeTransition($0) }
  }
}
