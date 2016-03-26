import UIKit

extension UIView {

  func prepareShadow() {
    layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.2).CGColor
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 5
    layer.shadowOpacity = 1
  }
}
