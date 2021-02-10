//
//  BlockedProgressView.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-08.
//

import UIKit

final class BlockedProgressView: UIView {
  private var progressView = ProgressView()
  private weak var timer: Timer?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  func setupProgressWith(startDate: Date, endDate: Date, onCompletion: @escaping () -> Void) {
    timer?.invalidate()
    let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
      guard endDate.timeIntervalSinceNow > 0 else {
        onCompletion()
        self?.isHidden = true
        self?.timer?.invalidate()
        return
      }
      let total = endDate.timeIntervalSince(startDate)
      let progress = Date().timeIntervalSince(startDate)
      self?.progressView.progress = CGFloat(progress / total)
    }
    
    self.timer = timer
    isHidden = false
  }
}

private extension BlockedProgressView {
  func setup() {
    backgroundColor = UIColor.white.withAlphaComponent(0.6)
    addProgressView()
    isHidden = true
  }
  
  func addProgressView() {
    addSubview(progressView)
    progressView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      progressView.centerYAnchor.constraint(equalTo: centerYAnchor),
      progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
      progressView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
      progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor)
    ])
  }
}
