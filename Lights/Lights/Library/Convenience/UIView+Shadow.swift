import UIKit

extension UIView {

  func prepareShadow(radius: CGFloat = 20, opacity: Float = 1) {
    layer.shadowColor = Color.General.shadow.CGColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowRadius = radius
    layer.shadowOpacity = opacity
  }
}
