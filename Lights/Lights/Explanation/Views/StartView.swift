import UIKit
import Ripple
import Walker

protocol StartViewDelegate {

  func startButtonDidPress()
  func shouldDisplayRipple()
}

class StartView: UIView {

  struct Dimensions {
    static let buttonSize: CGFloat = 180
    static let bottomOffset: CGFloat = 45
    static let indicatorSize: CGFloat = 14
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
    button.setTitleColor(Color.Background.bottom, forState: .Normal)
    button.backgroundColor = Color.Button.Start.background
    button.titleLabel?.font = Font.General.start
    button.layer.cornerRadius = Dimensions.buttonSize / 2
    button.prepareShadow()

    return button
    }()

  lazy var popView: UIView = {
    let view = UIView()
    view.backgroundColor = Color.Background.pop
    
    return view
  }()

  lazy var indicator: UIView = {
    let view = UIView()
    view.layer.borderColor = Color.General.life.CGColor
    view.layer.borderWidth = 2
    view.layer.cornerRadius = 7
    view.backgroundColor = Color.Background.top
    view.transform = CGAffineTransformMakeScale(0.1, 0.1)
    view.alpha = 0

    return view
  }()

  var delegate: StartViewDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(startButton)
    startButton.addSubview(popView)
    startButton.addSubview(indicator)

    [startButton, popView, indicator].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Action methods

  func startButtonDidPress() {
    delegate?.startButtonDidPress()
    startButton.layer.shadowOpacity = 0
    startButton.userInteractionEnabled = false
    animateBackground(Color.Button.Start.background)

    let boundsAnimation = CABasicAnimation(keyPath: "bounds.size")
    boundsAnimation.toValue = NSValue(CGSize: CGSize(
      width: Dimensions.buttonSize - 4, height: Dimensions.buttonSize - 4))

    let borderAnimation = CABasicAnimation(keyPath: "cornerRadius")
    borderAnimation.toValue = (Dimensions.buttonSize - 4) / 2

    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [boundsAnimation, borderAnimation]
    animationGroup.duration = 0.25
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
      popView.centerYAnchor.constraintEqualToAnchor(centerYAnchor),

      indicator.widthAnchor.constraintEqualToConstant(Dimensions.indicatorSize),
      indicator.heightAnchor.constraintEqualToConstant(Dimensions.indicatorSize),
      indicator.centerYAnchor.constraintEqualToAnchor(topAnchor, constant: 2),
      indicator.centerXAnchor.constraintEqualToAnchor(centerXAnchor)
      ])
  }

  // MARK: - Helper methods

  func animateBackground(color: UIColor) {
    UIView.animateWithDuration(0.25, animations: {
      self.startButton.backgroundColor = color
    })
  }

  func loadingAnimation() {
    indicator.alpha = 1

    spring(indicator, spring: 100, friction: 25, mass: 10) {
      $0.transform = CGAffineTransformIdentity
    }.finally {
      self.rotateView()
    }
  }

  func rotateView() {
    let duration: NSTimeInterval = 0.85
    let curve = Animation.Curve.Bezier(0.31, 0.62, 0.69, 0.44)

    animate(startButton, duration: duration, curve: curve) {
      $0.transform3D = CATransform3DMakeRotation(3.14, 0, 0, 1)
    }.chain(duration: duration, curve: curve) {
      $0.transform3D = CATransform3DMakeRotation(6.28, 0, 0, 1)
    }.finally {
      self.startButton.layer.transform = CATransform3DIdentity
      self.rotateView()
    }
  }
}

extension StartView {

  override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    popView.layer.removeAnimationForKey("pop")
    delegate?.shouldDisplayRipple()

    popView.layer.bounds.size = CGSize(
      width: Dimensions.buttonSize - 4, height: Dimensions.buttonSize - 4)
    popView.layer.cornerRadius = (Dimensions.buttonSize - 4) / 2
  }
}
