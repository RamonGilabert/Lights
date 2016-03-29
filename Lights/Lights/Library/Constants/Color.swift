import UIKit
import Hue

struct Color {

  struct General {
    static let life = UIColor.whiteColor()
    static let titles = General.life
    static let text = UIColor.whiteColor()
    static let shadow = UIColor.whiteColor().alpha(0.5)
    static let ripple = General.life.alpha(0.3)
    static let clear = UIColor.clearColor()
  }

  struct Background {
    static let general = UIColor.blackColor()
    static let top = UIColor.hex("131313")
    static let bottom = UIColor.hex("373C3F")
  }

  struct Button {

    struct Start {
      static let background = General.life
      static let hover = UIColor.hex("E37A4B")
    }
  }
}
