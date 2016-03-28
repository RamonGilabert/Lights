import UIKit

extension UIView {

  func prepareShadow() {
    layer.shadowColor = Color.General.shadow.CGColor
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 5
    layer.shadowOpacity = 1
  }
}
