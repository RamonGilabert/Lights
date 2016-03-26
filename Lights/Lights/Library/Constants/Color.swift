import UIKit
import Hue

struct Color {

  struct General {
    static let life = UIColor.hex("FE3B2F")
    static let background = UIColor.whiteColor()
    static let titles = General.life
    static let text = UIColor.hex("BEBEBE")
    static let shadow = UIColor.blackColor().alpha(0.2)
    static let ripple = General.life.alpha(0.3)
  }

  struct Button {

    struct Start {
      static let background = General.life
      static let hover = UIColor.hex("DC2E23")
    }
  }
}
