import UIKit
import Walker
import Transition

class PairingController: UIViewController {

  struct Dimensions {
    static let flameWidth: CGFloat = 75
    static let flameHeight: CGFloat = 130
    static let flameOffset: CGFloat = -60
    static let titleOffset: CGFloat = 15
    static let pairingOffset: CGFloat = -130
  }

  lazy var flameView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: Image.flame)
    imageView.contentMode = .ScaleAspectFit

    return imageView
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = Font.General.subtitle
    label.textColor = Color.General.text
    label.text = Text.Pairing.found

    return label
  }()

  lazy var pairingLabel: UILabel = {
    let label = UILabel()
    label.font = Font.General.detail
    label.textColor = Color.General.titles
    label.text = Text.Pairing.pairing

    return label
  }()

  lazy var transition: Transition = {
    let transition = Transition() { controller, show in
      guard let controller = controller as? PairingController else { return }

      [controller.flameView, controller.titleLabel, controller.pairingLabel].forEach {
        $0.transform = show ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.01, 0.01)
      }

      controller.view.alpha = 1
    }

    transition.spring = (0.6, 0.6)
    transition.animationDuration = 1

    return transition
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    transitioningDelegate = transition

    [flameView, titleLabel, pairingLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }

    view.backgroundColor = Color.General.background

    setupConstraints()
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

      pairingLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: width / 3),
      pairingLabel.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: Dimensions.pairingOffset)
      ])
  }
}
