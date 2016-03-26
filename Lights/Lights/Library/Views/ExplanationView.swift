import UIKit

class ExplanationView: UIView {

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = Font.General.title
    
    return label
  }()

  lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0

    return label
  }()
}
