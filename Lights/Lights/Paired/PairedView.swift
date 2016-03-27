import UIKit

protocol PairedViewDelegate {

  func startButtonDidPress()
}

class PairedView: UIView {

  struct Dimensions {
    static let pairedSize: CGFloat = 140
    static let pairedOffset: CGFloat = -55
    static let titleOffset: CGFloat = 35
    static let subtitleOffset: CGFloat = 20
    static let subtitleWidth: CGFloat = -56
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
    label.numberOfLines = 0
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

  var delegate: PairedViewDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    [pairedView, titleLabel, subtitleLabel, startButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }

    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
      pairedView.bottomAnchor.constraintEqualToAnchor(centerYAnchor, constant: Dimensions.pairedOffset),
      pairedView.centerXAnchor.constraintEqualToAnchor(centerXAnchor),

      titleLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
      titleLabel.topAnchor.constraintEqualToAnchor(centerYAnchor, constant: Dimensions.titleOffset),

      subtitleLabel.widthAnchor.constraintEqualToAnchor(widthAnchor, constant: Dimensions.subtitleWidth),
      subtitleLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
      subtitleLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: Dimensions.subtitleOffset),

      subtitleLabel.widthAnchor.constraintEqualToAnchor(widthAnchor, constant: Dimensions.buttonWidth),
      subtitleLabel.heightAnchor.constraintEqualToConstant(Dimensions.buttonHeight),
      subtitleLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
      subtitleLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: Dimensions.buttonOffset)
      ])
  }
}
