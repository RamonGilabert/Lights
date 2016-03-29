import UIKit

class ExplanationView: UIView {

  struct Dimensions {
    static let topOffset: CGFloat = 20
  }

  lazy var titleLabel: UILabel = UILabel()

  lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0

    return label
  }()

  init(title: String, subtitle: String) {
    super.init(frame: CGRectZero)

    titleLabel.attributedText = Attributes.title(title)
    subtitleLabel.attributedText = Attributes.subtitle(subtitle)

    [titleLabel, subtitleLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }

    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup constraints

  func setupConstraints() {
    NSLayoutConstraint.activateConstraints([
      titleLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
      titleLabel.topAnchor.constraintEqualToAnchor(topAnchor),

      subtitleLabel.widthAnchor.constraintEqualToAnchor(widthAnchor),
      subtitleLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
      subtitleLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: Dimensions.topOffset),
      subtitleLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
      ])
  }
}
