import UIKit

class StartController: UIViewController {

  lazy var startView: StartView = { [unowned self] in
    let view = StartView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self

    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(startView)
    view.backgroundColor = Color.General.background

    setupConstraints()
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
