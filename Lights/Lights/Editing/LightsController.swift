import UIKit
import Transition
import Walker
import Sugar

class LightsController: TapViewController {

  struct Dimensions {
    static let buttonWidth: CGFloat = -64
    static let buttonHeight: CGFloat = 60
    static let buttonOffset: CGFloat = -85

    static let wheelWidth: CGFloat = -60
    static let wheelOffset: CGFloat = 40

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

  lazy var turnButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(turnButtonDidPress), forControlEvents: .TouchUpInside)
    button.setTitle(Text.Editing.turnOn, forState: .Normal)
    button.setTitleColor(Color.General.life, forState: .Normal)
    button.titleLabel?.font = Font.General.button
    button.layer.borderColor = Color.General.life.CGColor
    button.layer.borderWidth = 2
    button.layer.cornerRadius = Dimensions.buttonHeight / 2

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

  let animation = (spring: CGFloat(40), friction: CGFloat(50), mass: CGFloat(50))

  override func viewDidLoad() {
    super.viewDidLoad()

    transitioningDelegate = transition
    view.backgroundColor = Color.General.background

    [searchButton, editingView, turnButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.transform = CGAffineTransformMakeTranslation(0, -UIScreen.mainScreen().bounds.height)
      view.addSubview($0)
    }

    setupConstraints()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    presentViews(true)
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

  func presentViews(show: Bool) {
    let transform = show
      ? CGAffineTransformIdentity
      : CGAffineTransformMakeTranslation(0, -UIScreen.mainScreen().bounds.height)

    spring(searchButton, delay: show ? 0.4 : 0,
           spring: animation.spring, friction: animation.friction, mass: animation.mass) {
      $0.transform = transform
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

  // MARK: - Constraints

  func setupConstraints() {
    NSLayoutConstraint.activateConstraints([
      searchButton.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: Dimensions.buttonTopOffset),
      searchButton.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: Dimensions.buttonRightOffset),

      editingView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: Dimensions.wheelWidth),
      editingView.heightAnchor.constraintEqualToAnchor(editingView.widthAnchor),
      editingView.topAnchor.constraintEqualToAnchor(searchButton.bottomAnchor, constant: Dimensions.wheelOffset),
      editingView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),

      turnButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: Dimensions.buttonWidth),
      turnButton.heightAnchor.constraintEqualToConstant(Dimensions.buttonHeight),
      turnButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      turnButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: Dimensions.buttonOffset)
      ])
  }
}

extension LightsController: EditingViewDelegate {

  func changeColor(color: UIColor) {
    editingView.imageView.tintColor = color
    editingView.indicatorOverlay.backgroundColor = color
    editingView.indicator.backgroundColor = color
  }

  func performRequest(color: UIColor) {

  }
}
