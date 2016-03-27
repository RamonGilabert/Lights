import UIKit
import Ripple
import Walker

class StartController: UIViewController {

  struct Dimensions {
    static let bottomOffset: CGFloat = -50
    static let flameHeight: CGFloat = 50
    static let flameOffset: CGFloat = 40
    static let explanationOffset: CGFloat = 14
    static let explanationWidth: CGFloat = -56
    static let searchingOffset: CGFloat = -130
  }

  lazy var startView: StartView = { [unowned self] in
    let view = StartView()
    view.delegate = self

    return view
  }()

  lazy var flameView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: Image.flame)
    imageView.contentMode = .ScaleAspectFit

    return imageView
  }()

  lazy var explanationView: ExplanationView = ExplanationView(title: Text.Explanation.title,
                                                              subtitle: Text.Explanation.subtitle)

  lazy var tapGesture: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(handleTapGesture))

    return gesture
  }()

  lazy var searchingLabel: UILabel = {
    let label = UILabel()
    label.font = Font.General.detail
    label.textColor = Color.General.titles
    label.text = Text.Detail.searching
    
    return label
  }()

  var timer = NSTimer()

  override func viewDidLoad() {
    super.viewDidLoad()

    [startView, flameView, explanationView, searchingLabel].forEach { view.addSubview($0) }
    view.backgroundColor = Color.General.background
    view.addGestureRecognizer(tapGesture)

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
    super.viewDidAppear(animated)

    animateController(true)
  }

  // MARK: - Action methods

  func handleTapGesture() {
    let location = tapGesture.locationInView(view)

    droplet(location,
            view: view,
            size: 25,
            duration: 1, multiplier: 2.5,
            color: Color.General.ripple)
  }

  // MARK: - Constraints

  func setupConstraints() {
    let width = UIScreen.mainScreen().bounds.width

    NSLayoutConstraint.activateConstraints([
      startView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      startView.bottomAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: Dimensions.bottomOffset),

      flameView.heightAnchor.constraintEqualToConstant(Dimensions.flameHeight),
      flameView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      flameView.topAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: Dimensions.flameOffset),

      explanationView.topAnchor.constraintEqualToAnchor(flameView.bottomAnchor, constant: Dimensions.explanationOffset),
      explanationView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      explanationView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: Dimensions.explanationWidth),

      searchingLabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor),
      searchingLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: width / 3 - 20),
      searchingLabel.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: Dimensions.searchingOffset)
      ])
  }

  // MARK: - Animations

  func animateController(show: Bool) {
    let animation = (spring: CGFloat(30), friction: CGFloat(50), mass: CGFloat(50))

    spring(startView, spring: animation.spring, friction: animation.friction, mass: animation.mass) {
      $0.transform = show ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.01, 0.01)
    }.finally {
      show ? self.stone() : calm()
    }

    animateExplanation(show)
  }

  func animateExplanation(show: Bool) {
    let transform = show ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(0, 300)
    let animation = (spring: CGFloat(30), friction: CGFloat(50), mass: CGFloat(50))

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

  // MARK - Helper methods

  func stone(duration: NSTimeInterval = 4) {
    ripple(startView.center,
           view: view,
           size: StartView.Dimensions.buttonSize,
           duration: duration, multiplier: 1.65, divider: 1.5,
           color: Color.General.ripple)
  }

  func timerDidFire() {
    guard let text = searchingLabel.text else { return }

    if text.characters.count == Text.Detail.searching.characters.count + 3 {
      searchingLabel.text = Text.Detail.searching
    } else {
      searchingLabel.text = text + "."
    }
  }
}

extension StartController: StartViewDelegate {

  func startButtonDidPress() {
    calm()
  }

  func shouldDisplayRipple() {
    stone(2)

    let animation = (spring: CGFloat(30), friction: CGFloat(50), mass: CGFloat(50))

    animateExplanation(false)

    spring(searchingLabel, delay: 0.5, spring: animation.spring, friction: animation.friction, mass: animation.mass) {
      $0.transform = CGAffineTransformIdentity
    }.finally {
      self.startView.rotateView()
      self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self,
        selector: #selector(self.timerDidFire), userInfo: nil, repeats: true)
    }
  }
}
