import UIKit
import Ripple

protocol StartViewDelegate {

  func startButtonDidPress()
  func shouldDisplayRipple()
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
    button.backgroundColor = Color.Button.Start.background
    button.titleLabel?.font = Font.General.start
    button.layer.cornerRadius = Dimensions.buttonSize / 2

    return button
    }()

  lazy var popView: UIView = {
    let view = UIView()
    view.backgroundColor = Color.General.background
    
    return view
  }()

  lazy var indicator: UIView = {
    let view = UIView()
    view.layer.borderColor = Color.General.life.CGColor
    view.layer.borderWidth = 2
    view.layer.cornerRadius = 7
    view.backgroundColor = Color.General.background

    return view
  }()

  var delegate: StartViewDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(startButton)
    startButton.addSubview(popView)

    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Action methods

  func startButtonDidPress() {
    delegate?.startButtonDidPress()
    animateBackground(Color.Button.Start.background)

    let boundsAnimation = CABasicAnimation(keyPath: "bounds.size")
    boundsAnimation.toValue = NSValue(CGSize: CGSize(
      width: Dimensions.buttonSize - 4, height: Dimensions.buttonSize - 4))

    let borderAnimation = CABasicAnimation(keyPath: "cornerRadius")
    borderAnimation.toValue = (Dimensions.buttonSize - 4) / 2

    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [boundsAnimation, borderAnimation]
    animationGroup.duration = 0.35
    animationGroup.delegate = self
    animationGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.62, 0.68, 0.29, 0.98)
    animationGroup.removedOnCompletion = false
    animationGroup.fillMode = kCAFillModeForwards

    popView.layer.addAnimation(animationGroup, forKey: "pop")
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
      startButton.leftAnchor.constraintEqualToAnchor(leftAnchor),

      popView.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
      popView.centerYAnchor.constraintEqualToAnchor(centerYAnchor)
      ])
  }

  // MARK: - Helper methods

  func animateBackground(color: UIColor) {
    UIView.animateWithDuration(0.25, animations: {
      self.startButton.backgroundColor = color
    })
  }
}

extension StartView {

  override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    delegate?.shouldDisplayRipple()
  }
}
