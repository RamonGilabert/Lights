import UIKit

class OfflineView: UIView {

  struct Dimensions {
    static let labelOffset: CGFloat = 8
  }

  lazy var sadView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFit
    imageView.image = UIImage(named: Image.offline)

    return imageView
  }()

  lazy var offlineLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.text = Text.Detail.offline
    label.font = Font.General.subtitle
    label.textColor = Color.General.text

    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    [sadView, offlineLabel].forEach {
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
      sadView.topAnchor.constraintEqualToAnchor(topAnchor),
      sadView.centerXAnchor.constraintEqualToAnchor(centerXAnchor),

      offlineLabel.topAnchor.constraintEqualToAnchor(sadView.bottomAnchor, constant: Dimensions.labelOffset),
      offlineLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
      offlineLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
      ])
  }
}
