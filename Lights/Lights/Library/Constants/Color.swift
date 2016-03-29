import UIKit
import Hue

struct Color {

  struct General {
    static let life = UIColor.hex("FF8B57")
    static let background = UIColor.hex("111314")
    static let titles = General.life
    static let text = UIColor.hex("D5D5D5")
    static let shadow = UIColor.blackColor().alpha(0.2)
    static let ripple = General.life.alpha(0.3)
  }

  struct Button {

    struct Start {
      static let background = General.life
      static let hover = UIColor.hex("E37A4B")
    }
  }
}
