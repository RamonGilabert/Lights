import UIKit
import Transition
import Sugar
import Walker

class PairingController: TapViewController {

  struct Dimensions {
    static let flameWidth: CGFloat = 75
    static let flameHeight: CGFloat = 130
    static let flameOffset: CGFloat = -60
    static let titleOffset: CGFloat = 15
    static let pairingOffset: CGFloat = -130
  }

  lazy var flameView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: Image.flame)?.imageWithRenderingMode(.AlwaysTemplate)
    imageView.tintColor = Color.General.life
    imageView.contentMode = .ScaleAspectFit

    return imageView
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.attributedText = Attributes.found(Text.Pairing.found)

    return label
  }()

  lazy var pairingLabel: UILabel = {
    let label = UILabel()
    label.attributedText = Attributes.detail(Text.Pairing.pairing)

    return label
  }()

  lazy var pairedView: PairedView = { [unowned self] in
    let view = PairedView()
    view.delegate = self

    return view
  }()

  lazy var transition: Transition = {
    let transition = Transition() { controller, show in
      guard let controller = controller as? PairingController else { return }

      [controller.flameView, controller.titleLabel, controller.pairingLabel].forEach {
        $0.transform = show ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.01, 0.01)
      }

      controller.view.alpha = 1
    }

    transition.spring = (0.6, 0.4)
    transition.animationDuration = 1

    return transition
  }()

  var timer = NSTimer()

  override func viewDidLoad() {
    super.viewDidLoad()

    transitioningDelegate = transition

    [flameView, titleLabel, pairingLabel, pairedView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }

    pairedView.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.height)

    setupConstraints()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self,
                                                   selector: #selector(timerDidFire),
                                                   userInfo: nil, repeats: true)

    delay(2) {
      let transform = CGAffineTransformMakeTranslation(0, -1000)
      let duration: NSTimeInterval = 1.5

      animate(self.flameView, duration: duration, curve: .EaseInOut) {
        $0.transform = transform
      }

      animate(self.titleLabel, duration: duration, delay: 0.15, curve: .EaseInOut) {
        $0.transform = transform
      }

      animate(self.pairingLabel, duration: duration, delay: 0.3, curve: .EaseInOut) {
        $0.transform = transform
      }

      spring(self.pairedView, delay: 0.6, spring: 40, friction: 50, mass: 50) {
        $0.transform = CGAffineTransformIdentity
      }
    }
  }

  // MARK: - Timer methods

  func timerDidFire() {
    guard let text = pairingLabel.attributedText?.string else { return }

    let transition = CATransition()
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionFade
    transition.duration = 0.4
    pairingLabel.layer.addAnimation(transition, forKey: "transition")

    if text.characters.count == Text.Pairing.pairing.characters.count + 3 {
      pairingLabel.attributedText = Attributes.detail(Text.Pairing.pairing)
    } else {
      pairingLabel.attributedText = Attributes.detail(text + ".")
    }

    pairingLabel.sizeToFit()
  }

  // MARK: - Constraints

  func setupConstraints() {
    let width = UIScreen.mainScreen().bounds.width

    NSLayoutConstraint.activateConstraints([
      flameView.widthAnchor.constraintEqualToConstant(Dimensions.flameWidth),
      flameView.heightAnchor.constraintEqualToConstant(Dimensions.flameHeight),
      flameView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      flameView.bottomAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: Dimensions.flameOffset),

      titleLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      titleLabel.topAnchor.constraintEqualToAnchor(flameView.bottomAnchor, constant: Dimensions.titleOffset),

      pairingLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: width / 3 - 10),
      pairingLabel.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: Dimensions.pairingOffset),

      pairedView.widthAnchor.constraintEqualToAnchor(view.widthAnchor),
      pairedView.heightAnchor.constraintEqualToAnchor(view.heightAnchor),
      pairedView.topAnchor.constraintEqualToAnchor(view.topAnchor),
      pairedView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
      ])
  }
}

extension PairingController: PairedViewDelegate {

  func startButtonDidPress() {
    closeDistilleries()

    animate(pairedView) {
      $0.transform = CGAffineTransformMakeScale(0.01, 0.01)
    }.finally {
      self.presentViewController(LightsController(), animated: true, completion: nil)
    }
  }
}
