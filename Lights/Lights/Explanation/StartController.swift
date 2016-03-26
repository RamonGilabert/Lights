import UIKit
import Ripple

class StartController: UIViewController {

  struct Dimensions {
    static let bottomOffset: CGFloat = -50
    static let flameHeight: CGFloat = 50
    static let flameOffset: CGFloat = 40
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

  lazy var explanationView: ExplanationView = ExplanationView()

  var rippled = false

  override func viewDidLoad() {
    super.viewDidLoad()

    [startView, flameView, explanationView].forEach { view.addSubview($0) }
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
      startView.bottomAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: Dimensions.bottomOffset),

      flameView.heightAnchor.constraintEqualToConstant(Dimensions.flameHeight),
      flameView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      flameView.topAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: Dimensions.flameOffset)
      ])
  }
}

extension StartController: StartViewDelegate {

  func startButtonDidPress() {
    // TODO: Implement
  }
}
