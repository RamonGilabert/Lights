import UIKit

protocol StartViewDelegate {

  func startButtonDidPress()
}

class StartView: UIView {

  struct Dimensions {
    static let buttonSize: CGFloat = 180
    static let bottomOffset: CGFloat = 45
  }

  lazy var startButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(startButtonDidPress),
                     forControlEvents: .TouchUpInside)
    button.addTarget(self, action: #selector(startButtonDidPressDown),
                     forControlEvents: .TouchDown)
    button.addTarget(self, action: #selector(startButtonDidCancel),
                     forControlEvents: .TouchDragExit)

    button.setTitle("Start".uppercaseString, forState: .Normal)
    button.setTitleColor(Color.General.background, forState: .Normal)
    button.prepareShadow()
    button.backgroundColor = Color.Button.Start.background
    button.layer.cornerRadius = Dimensions.buttonSize / 2
    button.titleLabel?.font = Font.General.start

    return button
    }()

  lazy var popView: UIView = {
    let view = UIView()
    view.backgroundColor = Color.General.background
    
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
    animateBackground(Color.Button.Start.background)
  }

  func startButtonDidPressDown() {
    animateBackground(Color.Button.Start.hover)
  }

  func startButtonDidCancel() {
    animateBackground(Color.Button.Start.background)
  }

  // MARK: - Constraints

  func setupConstraints() {
    NSLayoutConstraint.activateConstraints([
      startButton.widthAnchor.constraintEqualToConstant(Dimensions.buttonSize),
      startButton.heightAnchor.constraintEqualToConstant(Dimensions.buttonSize),
      startButton.topAnchor.constraintEqualToAnchor(topAnchor),
      startButton.rightAnchor.constraintEqualToAnchor(rightAnchor),
      startButton.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
      startButton.leftAnchor.constraintEqualToAnchor(leftAnchor)
      ])
  }

  // MARK: - Helper methods

  func animateBackground(color: UIColor) {
    UIView.animateWithDuration(0.25, animations: {
      self.startButton.backgroundColor = color
    })
  }
}
