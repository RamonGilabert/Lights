import UIKit

struct Font {

  private struct Brandon {
    static let bold = "BrandonGrotesque-Bold"
    static let regular = "BrandonGrotesque-Regular"
    static let light = "BrandonGrotesque-Light"
  }

  struct General {
    static let start = UIFont(name: Brandon.bold, size: 36)!
    static let button = UIFont(name: Brandon.bold, size: 20)!
    static let detail = UIFont(name: Brandon.bold, size: 23)!
    static let subtitle = UIFont(name: Brandon.regular, size: 14)!
  }

  struct Text {
    static let title = UIFont(name: Brandon.bold, size: 22)!
    static let subtitle = UIFont(name: Brandon.light, size: 14)!
  }
}
