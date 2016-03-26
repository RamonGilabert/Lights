import UIKit
import Ripple

class StartController: UIViewController {

  struct Dimensions {
    static let bottomOffset: CGFloat = -50
    static let flameHeight: CGFloat = 50
    static let flameOffset: CGFloat = 40
    static let explanationOffset: CGFloat = 14
    static let explanationWidth: CGFloat = -56
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

  lazy var searchingLabel: UILabel = {
    let label = UILabel()
    
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    [startView, flameView, explanationView].forEach { view.addSubview($0) }
    view.backgroundColor = Color.General.background

    setupConstraints()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    stone()
  }

  // MARK: - Constraints

  func setupConstraints() {
    NSLayoutConstraint.activateConstraints([
      startView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      startView.bottomAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: Dimensions.bottomOffset),

      flameView.heightAnchor.constraintEqualToConstant(Dimensions.flameHeight),
      flameView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      flameView.topAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: Dimensions.flameOffset),

      explanationView.topAnchor.constraintEqualToAnchor(flameView.bottomAnchor, constant: Dimensions.explanationOffset),
      explanationView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      explanationView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: Dimensions.explanationWidth)
      ])
  }

  // MARK - Helper methods

  func stone(duration: NSTimeInterval = 4) {
    ripple(startView.center,
           view: view,
           size: StartView.Dimensions.buttonSize,
           duration: duration, multiplier: 1.65, divider: 1.5,
           color: Color.General.ripple)
  }
}

extension StartController: StartViewDelegate {

  func startButtonDidPress() {
    calm()
  }

  func shouldDisplayRipple() {
    stone(2.5)
  }
}
