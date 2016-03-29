import UIKit

protocol PairedViewDelegate {

  func startButtonDidPress()
}

class PairedView: UIView {

  struct Dimensions {
    static let pairedSize: CGFloat = 140
    static let pairedOffset: CGFloat = -75
    static let titleOffset: CGFloat = 8
    static let subtitleOffset: CGFloat = 28
    static let subtitleWidth: CGFloat = -56
  }

  lazy var pairedView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFit
    imageView.image = UIImage(named: Image.paired)?.imageWithRenderingMode(.AlwaysTemplate)
    imageView.tintColor = Color.General.life

    return imageView
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.attributedText = Attributes.detail(Text.Pairing.paired)

    return label
  }()

  lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.attributedText = Attributes.subtitle(Text.Pairing.control)
    
    return label
  }()

  lazy var startButton: DetailButton = { [unowned self] in
    let button = DetailButton()
    button.addTarget(self, action: #selector(startButtonDidPress), forControlEvents: .TouchUpInside)
    button.setTitle(Text.Pairing.use, forState: .Normal)

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

      startButton.widthAnchor.constraintEqualToConstant(DetailButton.Dimensions.buttonWidth),
      startButton.heightAnchor.constraintEqualToConstant(DetailButton.Dimensions.buttonHeight),
      startButton.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
      startButton.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: DetailButton.Dimensions.buttonOffset)
      ])
  }
}
