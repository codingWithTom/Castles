//
//  ProgressView.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-08.
//

import UIKit

final class ProgressView: UIView {
  
  var progress: CGFloat = 0.0 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  override func draw(_ rect: CGRect) {
    // Drawing code
    let path = UIBezierPath()
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let startAngle: CGFloat = 3 / 2 * .pi
    let endAngle: CGFloat = startAngle - (2 * .pi) * progress
    
    path.addArc(withCenter: center, radius: bounds.midX * 0.9, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    
    path.lineWidth = bounds.width * 0.1
    UIColor.blue.setStroke()
    path.stroke()
  }
  
}

private extension ProgressView {
  func setup() {
    backgroundColor = .clear
    contentMode = .redraw
  }
}
