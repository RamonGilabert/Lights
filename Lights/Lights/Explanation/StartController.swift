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

      ripple(startView.center,
             view: view,
             size: StartView.Dimensions.buttonSize,
             duration: 4, multiplier: 1.65, divider: 1.5,
             color: Color.General.ripple)
    }
  }

  // MARK: - Constraints

  func setupConstraints() {
    NSLayoutConstraint.activateConstraints([
      startView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      startView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 110)
      ])
  }
}

extension StartController: StartViewDelegate {

  func startButtonDidPress() {
    // TODO: Implement
  }
}
