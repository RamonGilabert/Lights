import UIKit

extension UIView {

  func prepareShadow() {
    layer.shadowColor = Color.General.shadow.CGColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowRadius = 20
    layer.shadowOpacity = 1
  }
}
