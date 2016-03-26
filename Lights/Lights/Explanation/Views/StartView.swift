import UIKit

protocol StartViewDelegate {

  func startButtonDidPress()
}

class StartView: UIView {

  struct Dimensions {
    static let buttonSize: CGFloat = 180
  }

  lazy var startButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(startButtonDidPress),
                     forControlEvents: .TouchUpInside)
    button.backgroundColor = UIColor.blackColor()
    button.translatesAutoresizingMaskIntoConstraints = false

    return button
    }()

  lazy var popView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()

  var delegate: StartViewDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    [startButton, popView].forEach { addSubview($0) }

    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Action methods

  func startButtonDidPress() {
    delegate?.startButtonDidPress()
  }

  // MARK: - Constraints

  func setupConstraints() {
    NSLayoutConstraint.activateConstraints([
      startButton.widthAnchor.constraintEqualToConstant(Dimensions.buttonSize),
      startButton.heightAnchor.constraintEqualToConstant(Dimensions.buttonSize),
      startButton.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
      startButton.centerYAnchor.constraintEqualToAnchor(centerYAnchor, constant: 110)
      ])
  }
}
