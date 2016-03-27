import UIKit
import Walker
import Transition

class PairingController: UIViewController {

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
    label.text = Text.Detail

    return label
  }()

  lazy var pairingLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
