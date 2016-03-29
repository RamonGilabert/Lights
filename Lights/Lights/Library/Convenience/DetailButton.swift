import UIKit

class DetailButton: UIButton {

  struct Dimensions {
    static let buttonWidth: CGFloat = 210
    static let buttonHeight: CGFloat = 50
    static let buttonOffset: CGFloat = -70
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    setTitleColor(Color.Background.bottom, forState: .Normal)
    titleLabel?.font = Font.General.button
    backgroundColor = Color.General.life
    layer.cornerRadius = Dimensions.buttonHeight / 2
    prepareShadow(8, opacity: 0.3)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
