import UIKit
import Transition
import Walker
import Sugar
import Ripple

class LightsController: TapViewController {

  struct Dimensions {
    static let wheelWidth: CGFloat = -130
    static let wheelOffset: CGFloat = 60

    static let buttonTopOffset: CGFloat = 36
    static let buttonRightOffset: CGFloat = -20
  }

  lazy var searchButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(searchButtonDidPress), forControlEvents: .TouchUpInside)
    button.setImage(UIImage(named: Image.search)?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
    button.tintColor = Color.General.life

    return button
  }()

  lazy var turnButton: DetailButton = { [unowned self] in
    let button = DetailButton()
    button.addTarget(self, action: #selector(turnButtonDidPress), forControlEvents: .TouchUpInside)
    button.setTitle(Text.Editing.turnOn, forState: .Normal)

    return button
  }()

  lazy var editingView: EditingView = { [unowned self] in
    let view = EditingView()
    view.delegate = self
    view.userInteractionEnabled = true

    return view
  }()

  lazy var transition: Transition = {
    let transition = Transition() { controller, show in
      controller.view.alpha = 1
    }

    transition.animationDuration = 0.15

    return transition
  }()

  let animation = (spring: CGFloat(90), friction: CGFloat(80), mass: CGFloat(80))

  override func viewDidLoad() {
    super.viewDidLoad()

    transitioningDelegate = transition

    [searchButton, editingView, turnButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.transform = CGAffineTransformMakeTranslation(0, -UIScreen.mainScreen().bounds.height)
      view.addSubview($0)
    }

    setupConstraints()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    guard let light = Locker.light() else { return }

    turnButton.setTitle(light.status ? Text.Editing.turnOn : Text.Editing.turnOff, forState: .Normal)

    let color = UIColor(red: light.red * 255, green: light.green * 255, blue: light.blue * 255, alpha: 1)
    changeColor(color)
  }

  // MARK: - Action methods

  func searchButtonDidPress() {
    presentViews(false)

    delay(0.75) {
      self.presentViewController(StartController(), animated: true, completion: nil)
    }
  }

  func turnButtonDidPress() {
    let shouldTurn = turnButton.titleForState(.Normal) == Text.Editing.turnOn
    let title = shouldTurn ? Text.Editing.turnOff : Text.Editing.turnOn

    turnButton.setTitle(title, forState: .Normal)
  }

  // MARK: - Animations

  override func presentViews(show: Bool) {
    let transform = show
      ? CGAffineTransformIdentity
      : CGAffineTransformMakeTranslation(0, -UIScreen.mainScreen().bounds.height)

    calm()

    spring(searchButton, delay: show ? 0.4 : 0,
           spring: animation.spring, friction: animation.friction, mass: animation.mass) {
      $0.transform = transform
    }.finally {
      if show {
        ripple(self.editingView.center,
          view: self.view,
          size: 120,
          duration: 4, multiplier: 3.2, divider: 3,
          color: Color.General.ripple.alpha(0.1))
      }
    }

    spring(editingView, delay: 0.2,
           spring: animation.spring, friction: animation.friction, mass: animation.mass) {
      $0.transform = transform
    }

    spring(turnButton, delay: show ? 0 : 0.4,
           spring: animation.spring, friction: animation.friction, mass: animation.mass) {
      $0.transform = transform
    }
  }
}

extension LightsController: EditingViewDelegate {

  func changeColor(color: UIColor) {
    editingView.imageView.tintColor = color
    editingView.indicatorOverlay.backgroundColor = color
    editingView.indicator.backgroundColor = color
    editingView.imageView.layer.shadowColor = color.alpha(0.5).CGColor
    searchButton.tintColor = color
    turnButton.backgroundColor = color
    turnButton.layer.shadowColor = color.alpha(0.5).CGColor
  }

  func performRequest(color: UIColor) {
    let on = turnButton.titleForState(.Normal) == Text.Editing.turnOn

    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    Locker.save([
      Locker.Key.status : on,
      Locker.Key.red : red,
      Locker.Key.green : green,
      Locker.Key.blue : blue
      ])

    Socket.change()
  }
}
