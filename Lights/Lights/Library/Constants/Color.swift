import UIKit
import Hue

struct Color {

  struct General {
    static let life = UIColor.whiteColor()
    static let titles = General.life
    static let text = General.life
    static let shadow = General.life.alpha(0.5)
    static let ripple = General.life.alpha(0.3)
    static let clear = UIColor.clearColor()
    static let initial = UIColor.hex("00E0FF")
  }

  struct Background {
    static let general = UIColor.blackColor()
    static let top = UIColor.hex("131313")
    static let bottom = UIColor.hex("373C3F")
    static let pop = UIColor.hex("212323")
  }

  struct Button {

    static let background = General.life

    struct Start {
      static let background = General.life
      static let hover = UIColor.hex("E5E5E5")
    }
  }
}
