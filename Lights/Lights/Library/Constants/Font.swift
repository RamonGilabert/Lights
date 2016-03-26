import UIKit

struct Font {

  private struct Brandon {
    static let bold = "Brandon Grotesque Bold"
  }

  private struct Lato {
    static let bold = "Lato Bold"
  }

  struct General {
    static let start = UIFont(name: Brandon.bold, size: 36)!
    static let button = UIFont(name: Brandon.bold, size: 22)!
  }
}
