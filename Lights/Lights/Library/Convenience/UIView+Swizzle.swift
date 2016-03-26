import UIKit

extension UIView {

  override public class func initialize() {
    struct Static {
      static var token: dispatch_once_t = 0
    }

    dispatch_once(&Static.token) {
      let originalSelector = #selector(willMoveToSuperview)
      let swizzledSelector = #selector(swizzle_willMoveToSuperview)

      let originalMethod = class_getInstanceMethod(self, originalSelector)
      let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)

      let didAddMethod = class_addMethod(self, originalSelector,
                                         method_getImplementation(swizzledMethod),
                                         method_getTypeEncoding(swizzledMethod))

      if didAddMethod {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
      } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
      }
    }
  }

  func swizzle_willMoveToSuperview() {
    swizzle_willMoveToSuperview()

    layer.drawsAsynchronously = true
    translatesAutoresizingMaskIntoConstraints = false
  }
}
