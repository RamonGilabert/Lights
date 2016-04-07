import UIKit
import Sugar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  lazy var controller: LightsController = LightsController()
  lazy var startController: StartController = StartController()

  lazy var launchScreen: UIImageView = {
    let imageView = UIImageView()
    imageView.frame = UIScreen.mainScreen().bounds
    imageView.contentMode = .ScaleAspectFit

    return imageView
  }()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)

    if Locker.light() != nil {
      controller.view.addSubview(launchScreen)
      window?.rootViewController = controller

      Network.fetch(Request.Lights(), completion: { JSON, error in
        UIView.animateWithDuration(0.3, animations: {
          self.launchScreen.transform = CGAffineTransformMakeScale(3, 3)
          self.launchScreen.alpha = 0
          }, completion: { _ in
            self.launchScreen.removeFromSuperview()
        })

        guard error == nil else { return }

        Locker.save(JSON)
        Socket.connect()
      })
    } else {
      window?.rootViewController = startController
    }

    window?.makeKeyAndVisible()
    
    return true
  }
}
