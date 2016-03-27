import UIKit

protocol PairedControllerDelegate {

  func startButtonDidPress()
}

class PairedController: UIViewController {

  struct Dimensions {
    static let pairedSize: CGFloat = 140
    static let pairedOffset: CGFloat = -55
    static let titleOffset: CGFloat = 35
    static let subtitleOffset: CGFloat = 20
    static let buttonWidth: CGFloat = -64
    static let buttonHeight: CGFloat = 60
    static let buttonOffset: CGFloat = -55
  }

  lazy var pairedView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFit
    imageView.image = UIImage(named: Image.paired)

    return imageView
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = Text.Pairing.paired
    label.textColor = Color.General.life
    label.font = Font.Text.title

    return label
  }()

  lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.attributedText = Attributes.subtitle(Text.Pairing.control)
    
    return label
  }()

  lazy var startButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: #selector(startButtonDidPress), forControlEvents: .TouchUpInside)
    button.setTitle(Text.Pairing.use, forState: .Normal)
    button.titleLabel?.font = Font.General.button
    button.layer.borderColor = Color.General.life.CGColor
    button.layer.borderWidth = 2
    button.layer.cornerRadius = Dimensions.buttonHeight / 2

    return button
  }()

  var delegate: PairedControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    [pairedView, titleLabel, subtitleLabel, startButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }

    setupConstraints()
  }

  // MARK: - Action methods

  func startButtonDidPress() {
    delegate?.startButtonDidPress()
  }

  // MARK: - Constraints

  func setupConstraints() {
    NSLayoutConstraint.activateConstraints([
      pairedView.widthAnchor.constraintEqualToConstant(Dimensions.pairedSize),
      pairedView.heightAnchor.constraintEqualToConstant(Dimensions.pairedSize),
      pairedView.bottomAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -Dimensions.pairedOffset),
      pairedView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),

      titleLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      titleLabel.topAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: Dimensions.titleOffset),

      subtitleLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      subtitleLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: Dimensions.subtitleOffset),

      subtitleLabel.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: Dimensions.buttonWidth),
      subtitleLabel.heightAnchor.constraintEqualToConstant(Dimensions.buttonHeight),
      subtitleLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      subtitleLabel.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: Dimensions.buttonOffset)
      ])
  }
}
