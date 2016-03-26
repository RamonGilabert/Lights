import UIKit

extension UIView {

  override public class func initialize() {
    struct Static {
      static var token: dispatch_once_t = 0
    }

    dispatch_once(&Static.token) {
      let originalSelector = #selector(UIView.init(frame:))
      let swizzledSelector = #selector(UIView.swizzle_init(frame:))

      let originalMethod = class_getClassMethod(self, originalSelector)
      let swizzledMethod = class_getClassMethod(self, swizzledSelector)

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

  class func swizzle_init(frame frame: CGRect) {
    swizzle_init(frame: frame)
    UIView().translatesAutoresizingMaskIntoConstraints = false
  }
}
