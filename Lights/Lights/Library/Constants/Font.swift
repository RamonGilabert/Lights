import UIKit

struct Font {

  private struct Brandon {
    static let bold = "BrandonGrotesque-Bold"
  }

  private struct Lato {
    static let bold = "Lato-Bold"
  }

  struct General {
    static let start = UIFont(name: Brandon.bold, size: 36)!
    static let button = UIFont(name: Brandon.bold, size: 22)!
  }

  struct Text {
    static let title = UIFont(name: Lato.bold, size: 30)!
    static let subtitle = UIFont(name: Lato.bold, size: 18)!
  }
}
