import UIKit
import Transition
import Sugar
import Walker

class PairingController: TapViewController {

  struct Dimensions {
    static let flameWidth: CGFloat = 75
    static let flameHeight: CGFloat = 130
    static let flameOffset: CGFloat = -60
    static let titleOffset: CGFloat = 15
    static let pairingOffset: CGFloat = -130
  }

  lazy var flameView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: Image.flame)?.imageWithRenderingMode(.AlwaysTemplate)
    imageView.tintColor = Color.General.life
    imageView.contentMode = .ScaleAspectFit

    return imageView
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.attributedText = Attributes.found(Text.Pairing.found)

    return label
  }()

  lazy var pairingLabel: UILabel = {
    let label = UILabel()
    label.attributedText = Attributes.detail(Text.Pairing.pairing)

    return label
  }()

  lazy var pairedView: PairedView = { [unowned self] in
    let view = PairedView()
    view.delegate = self

    return view
  }()

  lazy var transition: Transition = {
    let transition = Transition() { controller, show in
      guard let controller = controller as? PairingController else { return }

      [controller.flameView, controller.titleLabel, controller.pairingLabel].forEach {
        $0.transform = show ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.01, 0.01)
      }

      controller.view.alpha = 1
    }

    transition.spring = (0.6, 0.4)
    transition.animationDuration = 1

    return transition
  }()

  var timer = NSTimer()

  override func viewDidLoad() {
    super.viewDidLoad()

    transitioningDelegate = transition

    [flameView, titleLabel, pairingLabel, pairedView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }

    pairedView.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.height)

    setupConstraints()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self,
                                                   selector: #selector(timerDidFire),
                                                   userInfo: nil, repeats: true)

    delay(2) {
      closeDistilleries()

      let transform = CGAffineTransformMakeTranslation(0, -1000)
      let duration: NSTimeInterval = 0.6

      animate(self.flameView, duration: duration, curve: .EaseInOut) {
        $0.transform = transform
      }

      animate(self.titleLabel, duration: duration, delay: 0.15, curve: .EaseInOut) {
        $0.transform = transform
      }

      animate(self.pairingLabel, duration: duration, delay: 0.3, curve: .EaseInOut) {
        $0.transform = transform
      }
    }
  }

  // MARK: - Timer methods

  func timerDidFire() {
    guard let text = pairingLabel.attributedText?.string else { return }

    let transition = CATransition()
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionFade
    transition.duration = 0.4
    pairingLabel.layer.addAnimation(transition, forKey: "transition")

    if text.characters.count == Text.Pairing.pairing.characters.count + 3 {
      pairingLabel.attributedText = Attributes.detail(Text.Pairing.pairing)
    } else {
      pairingLabel.attributedText = Attributes.detail(text + ".")
    }

    pairingLabel.sizeToFit()
  }

  // MARK: - Helper methods

  override func presentViews(show: Bool = true) {
    guard !CGAffineTransformIsIdentity(flameView.transform) else { return }

    UIView.animateWithDuration(0.5, animations: {
      self.pairedView.alpha = show ? 1 : 0
      self.pairedView.transform = show ? CGAffineTransformIdentity : CGAffineTransformMakeScale(2, 2)
    })
  }
}

extension PairingController: PairedViewDelegate {

  func startButtonDidPress() {
    closeDistilleries()

    animate(pairedView) {
      $0.transform = CGAffineTransformMakeScale(0.01, 0.01)
    }.finally {
      self.presentViewController(LightsController(), animated: true, completion: nil)
    }
  }
}

extension PairingController: BluetoothPairedDelegate {

  func pairedDevice(token: String, controllerID: String) {
    guard let controllerID = Int(controllerID) else { return }

    Locker.token(token)
    Locker.controller(controllerID)
    
    Network.fetch(Request.Lights(), completion: { JSON, error in
      guard let JSON = JSON.first where error == nil else { return }

      let transform = CGAffineTransformMakeTranslation(0, -1000)

      closeDistilleries()

      [self.flameView, self.titleLabel, self.pairingLabel].forEach { $0.transform = transform }

      spring(self.pairedView, spring: 100, friction: 70, mass: 70) {
        $0.transform = CGAffineTransformIdentity
      }

      Locker.save(JSON)
      Socket.connect()
    })
  }
}
