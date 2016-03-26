import UIKit
import Ripple

class StartController: UIViewController {

  lazy var startView: StartView = { [unowned self] in
    let view = StartView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self

    return view
  }()

  var rippled = false

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(startView)
    view.backgroundColor = Color.General.background

    setupConstraints()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    if !rippled {
      rippled = true

      ripple(startView.startButton.center,
             view: startView,
             size: StartView.Dimensions.buttonSize,
             duration: 4, multiplier: 1.65, divider: 1.5,
             color: Color.General.ripple)
    }
  }

  // MARK: - Constraints

  func setupConstraints() {
    NSLayoutConstraint.activateConstraints([
      startView.widthAnchor.constraintEqualToAnchor(view.widthAnchor),
      startView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 0.5),
      startView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      startView.topAnchor.constraintEqualToAnchor(view.topAnchor)
      ])
  }
}

extension StartController: StartViewDelegate {

  func startButtonDidPress() {
    // TODO: Implement
  }
}
