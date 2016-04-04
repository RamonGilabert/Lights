import UIKit
import Ripple
import Walker
import Sugar
import Transition

class StartController: TapViewController {

  struct Dimensions {
    static let bottomOffset: CGFloat = -50
    static let flameHeight: CGFloat = 56
    static let flameOffset: CGFloat = 40
    static let explanationOffset: CGFloat = 22
    static let explanationWidth: CGFloat = -56
    static let searchingWidth: CGFloat = 90
    static let searchingOffset: CGFloat = -130
  }

  lazy var startView: StartView = { [unowned self] in
    let view = StartView()
    view.delegate = self

    return view
  }()

  lazy var flameView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: Image.flame)?.imageWithRenderingMode(.AlwaysTemplate)
    imageView.tintColor = Color.General.life
    imageView.contentMode = .ScaleAspectFit

    return imageView
  }()

  lazy var explanationView: ExplanationView = ExplanationView(title: Text.Explanation.title,
                                                              subtitle: Text.Explanation.subtitle)

  lazy var searchingLabel: UILabel = {
    let label = UILabel()
    label.attributedText = Attributes.detail(Text.Detail.searching)

    return label
  }()

  lazy var transition: Transition = {
    let transition = Transition() { controller, show in
      controller.view.alpha = 1
    }

    transition.animationDuration = 0.15

    return transition
  }()

  lazy var pairingController: PairingController = PairingController()

  let animation = (spring: CGFloat(90), friction: CGFloat(80), mass: CGFloat(80))
  var timer = NSTimer()

  override func viewDidLoad() {
    super.viewDidLoad()

    transitioningDelegate = transition

    [startView, flameView, explanationView, searchingLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }

    setupConstraints()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    startView.transform = CGAffineTransformMakeScale(0.01, 0.01)
    [flameView, explanationView.titleLabel, explanationView.subtitleLabel, searchingLabel].forEach {
      $0.transform = CGAffineTransformMakeTranslation(0, 300)
    }
  }

  override func viewDidAppear(animated: Bool) {
    closeDistilleries()
    
    super.viewDidAppear(animated)
  }

  // MARK: - Animations

  override func presentViews(show: Bool) {
    spring(startView, spring: animation.spring, friction: animation.friction, mass: animation.mass) {
      $0.transform = show ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.00001, 0.00001)
    }.finally {
      show ? self.stone() : calm()
    }

    animateExplanation(show)
  }

  func animateExplanation(show: Bool) {
    let transform = show ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(0, 300)

    spring(flameView, delay: show ? 0 : 0.4,
           spring: animation.spring, friction: animation.friction, mass: animation.mass) {
      $0.transform = transform
    }

    spring(explanationView.titleLabel, delay: 0.2,
           spring: animation.spring, friction: animation.friction, mass: animation.mass) {
      $0.transform = transform
    }

    spring(explanationView.subtitleLabel, delay: show ? 0.4 : 0.01,
           spring: animation.spring, friction: animation.friction, mass: animation.mass) {
      $0.transform = transform
    }
  }

  func lightFound() {
    timer.invalidate()
    calm()

    UIView.animateWithDuration(0.3, animations: {
      self.startView.indicator.transform = CGAffineTransformMakeScale(0.1, 0.1)
    })

    delay(0.5) {
      closeDistilleries()

      animate(self.startView, self.searchingLabel, duration: 0.1) {
        [$0, $1].forEach { $0.transform = CGAffineTransformMakeScale(1.1, 1.1) }
      }.chains(duration: 0.3) {
        [$0, $1].forEach { $0.transform = CGAffineTransformMakeScale(0.01, 0.01) }
      }.finally {
        closeDistilleries()
        self.presentViewController(self.pairingController, animated: true, completion: nil)
      }
    }
  }

  // MARK - Helper methods

  func stone(duration: NSTimeInterval = 4, multiplier: CGFloat = 1.65, divider: CGFloat = 1.5) {
    ripple(startView.center,
           view: view,
           size: StartView.Dimensions.buttonSize,
           duration: duration, multiplier: multiplier, divider: divider,
           color: Color.General.ripple)
  }

  func timerDidFire() {
    guard let text = searchingLabel.attributedText?.string else { return }

    let transition = CATransition()
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionFade
    transition.duration = 0.4
    searchingLabel.layer.addAnimation(transition, forKey: "transition")

    if text.characters.count == Text.Detail.searching.characters.count + 3 {
      searchingLabel.attributedText = Attributes.detail(Text.Detail.searching)
    } else {
      searchingLabel.attributedText = Attributes.detail(text + ".")
    }

    searchingLabel.sizeToFit()
  }
}

extension StartController: StartViewDelegate {

  func startButtonDidPress() {
    calm()
  }

  func shouldDisplayRipple() {
    stone(2.5, multiplier: 1.65, divider: 2)

    animateExplanation(false)

    spring(searchingLabel, delay: 0.45, spring: animation.spring, friction: animation.friction, mass: animation.mass) {
      $0.transform = CGAffineTransformIdentity
    }.finally {
      bluetooth = Bluetooth()
      bluetooth.delegate = self

      self.startView.loadingAnimation()
      self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self,
        selector: #selector(self.timerDidFire), userInfo: nil, repeats: true)
    }
  }
}

extension StartController: BluetoothDelegate {

  func shouldShowMessage(message: String) {
    print(message) // TODO: Handle the error.
  }
}
