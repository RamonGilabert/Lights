import UIKit

struct Attributes {

  static func title(text: String) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: text)

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .Center

    attributedString.addAttributes([
      NSFontAttributeName : Font.Text.title,
      NSForegroundColorAttributeName : Color.General.text,
      NSParagraphStyleAttributeName : paragraphStyle,
      NSKernAttributeName : 4],
                                   range: NSRange(location: 0, length: text.characters.count))

    return attributedString
  }

  static func subtitle(text: String) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: text)

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .Center
    paragraphStyle.lineSpacing = 6

    attributedString.addAttributes([
      NSFontAttributeName : Font.Text.subtitle,
      NSForegroundColorAttributeName : Color.General.text,
      NSParagraphStyleAttributeName : paragraphStyle,
      NSKernAttributeName : 0.3],
                                   range: NSRange(location: 0, length: text.characters.count))

    return attributedString
  }
}
