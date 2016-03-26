import UIKit

struct Color {

  struct General {
    static let life = UIColor(red: 254/255, green: 59/255, blue: 47/255, alpha: 1.00)
    static let background = UIColor.whiteColor()
    static let titles = General.life
    static let text = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
    static let shadow = UIColor.blackColor().colorWithAlphaComponent(0.2)
    static let ripple = General.life.colorWithAlphaComponent(0.3)
  }
}
