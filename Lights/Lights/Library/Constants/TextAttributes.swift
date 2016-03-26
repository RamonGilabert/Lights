import UIKit

struct Attributes {

  static func subtitle(text: String) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: text)

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .Center
    paragraphStyle.lineSpacing = 3

    attributedString.addAttributes([
      NSFontAttributeName : Font.Text.subtitle,
      NSForegroundColorAttributeName : Color.General.text,
      NSParagraphStyleAttributeName : paragraphStyle],
                                   range: NSRange(location: 0, length: text.characters.count))

    return attributedString
  }
}
