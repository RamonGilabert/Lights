import UIKit

class DetailButton: UIButton {

  struct Dimensions {
    static let buttonWidth: CGFloat = 210
    static let buttonHeight: CGFloat = 50
    static let buttonOffset: CGFloat = -85
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    setTitleColor(Color.Background.bottom, forState: .Normal)
    titleLabel?.font = Font.General.button
    backgroundColor = Color.Button.background
    layer.cornerRadius = Dimensions.buttonHeight / 2
    prepareShadow(10, opacity: 0.7)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
