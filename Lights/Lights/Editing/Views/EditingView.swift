import UIKit

protocol EditingViewDelegate {

  func changeColor(color: UIColor)
  func performRequest(color: UIColor, radius: CGFloat)
}

class EditingView: UIView {

  struct Dimensions {
    static let size: CGFloat = UIScreen.mainScreen().bounds.width + LightsController.Dimensions.wheelWidth
    static let border: CGFloat = 4
    static let indicator: CGFloat = 14
    static let indicatorOverlay: CGFloat = 18
    static let imageWidth: CGFloat = 54
    static let imageHeight: CGFloat = 88
  }

  typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
  typealias HSV = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)

  lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFit
    imageView.image = UIImage(named: Image.flame)?.imageWithRenderingMode(.AlwaysTemplate)
    imageView.tintColor = Color.General.life
    imageView.prepareShadow(10, opacity: 0.7)

    return imageView
  }()

  lazy var colorWheel: UIView = {
    let view = UIView()
    view.layer.cornerRadius = Dimensions.size / 2
    view.clipsToBounds = true

    return view
  }()

  lazy var mask: CAShapeLayer = {
    let layer = CAShapeLayer()
    let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0,
      width: Dimensions.size, height: Dimensions.size),
                            cornerRadius: Dimensions.size / 2)
    layer.path = path.CGPath
    layer.frame = CGRect(x: 0, y: 0, width: Dimensions.size, height: Dimensions.size)

    return layer
  }()

  lazy var overlay: UIView = {
    let view = UIView()
    view.backgroundColor = Color.Background.pop
    view.layer.cornerRadius = (Dimensions.size - Dimensions.border * 2) / 2

    return view
  }()

  lazy var indicatorOverlay: UIView = {
    let view = UIView()
    view.frame = CGRect(x: (Dimensions.size - Dimensions.indicator) / 2,
                        y: (Dimensions.border - Dimensions.indicator) / 2,
                        width: Dimensions.indicator, height: Dimensions.indicator)
    view.backgroundColor = Color.General.life
    view.layer.cornerRadius = Dimensions.indicatorOverlay / 2

    return view
  }()

  lazy var indicator: UIView = {
    let view = UIView()
    view.backgroundColor = Color.General.life
    view.layer.borderColor = Color.Background.pop.CGColor
    view.layer.borderWidth = 2
    view.layer.cornerRadius = Dimensions.indicator / 2
    view.userInteractionEnabled = true
    view.translatesAutoresizingMaskIntoConstraints = false

    return view
  }()

  lazy var panGesture: UIPanGestureRecognizer = { [unowned self] in
    let panGesture = UIPanGestureRecognizer()
    panGesture.addTarget(self, action: #selector(handlePanGesture))
    panGesture.minimumNumberOfTouches = 1
    panGesture.cancelsTouchesInView = false
    panGesture.delegate = self

    return panGesture
  }()

  var delegate: EditingViewDelegate?
  var previousRadius = Dimensions.size / 2
  var previousPoint = CGPointZero

  override init(frame: CGRect) {
    super.init(frame: frame)

    let wheelLayer = CALayer()
    wheelLayer.frame = CGRect(x: 0, y: 0, width: Dimensions.size, height: Dimensions.size)
    wheelLayer.contents = createWheel()
    colorWheel.layer.addSublayer(wheelLayer)

    [colorWheel, overlay, imageView, indicatorOverlay].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }

    colorWheel.layer.mask = mask
    indicatorOverlay.addSubview(indicator)
    indicatorOverlay.addGestureRecognizer(panGesture)

    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Action methods

  func handlePanGesture() {
    let point = indicatorLocation(panGesture.locationInView(self))
    let x = abs(point.x - colorWheel.center.x)
    let y = abs(point.y - colorWheel.center.y)
    let reference = saturation(point)
    let color = UIColor(hue: reference.hue,
                        saturation: reference.saturation, brightness: 1, alpha: 1)
    let size = sqrt(x * x + y * y) * 2

    previousRadius = size / 2
    previousPoint = point

    if panGesture.state == .Began {
      previousRadius = overlay.frame.size.width / 2 + Dimensions.border
      previousPoint = indicatorOverlay.center
    } else if size >= Dimensions.imageHeight + 40 {
      let pathFrame = CGRect(x: (colorWheel.frame.width - size) / 2,
                             y: (colorWheel.frame.height - size) / 2,
                             width: size, height: size)
      let path = UIBezierPath(roundedRect: pathFrame, cornerRadius: size / 2)
      let constantX: CGFloat = point.x - colorWheel.center.x > 0 ? -1 : 1
      let constantY: CGFloat = point.y - colorWheel.center.y > 0 ? -1 : 1
      let difference = size / Dimensions.size
      let imageDifference: CGFloat = 50

      delegate?.changeColor(color)

      mask.path = path.CGPath
      indicatorOverlay.center = CGPoint(x: point.x + constantX, y: point.y + constantY * Dimensions.border / 2)
      overlay.frame.size = CGSize(width: size - Dimensions.border * 2,
                                  height: size - Dimensions.border * 2)
      overlay.center = colorWheel.center
      imageView.frame.size = CGSize(width: Dimensions.imageWidth * difference + imageDifference * (1 - difference),
                                    height: Dimensions.imageHeight * difference + imageDifference * (1 - difference))
      imageView.center = colorWheel.center
      overlay.layer.cornerRadius = overlay.frame.width / 2
    }

    delegate?.performRequest(color, radius: size >= Dimensions.imageHeight + 40 ? size / 2 : Dimensions.size / 2)
  }

  func indicatorLocation(location: CGPoint) -> CGPoint {
    let radius = Dimensions.size / 2
    let center = colorWheel.center
    let x: CGFloat = location.x - center.x
    let y: CGFloat = location.y - center.y
    let distance = sqrt(x * x + y * y)
    var point = location

    if distance > radius {
      let theta = atan2(y, x)
      point = CGPoint(x: radius * cos(theta) + center.x,
                      y: radius * sin(theta) + center.y)
    }

    return point
  }

  // MARK: - Constraints

  func setupConstraints() {
    NSLayoutConstraint.activateConstraints([
      colorWheel.widthAnchor.constraintEqualToConstant(Dimensions.size),
      colorWheel.heightAnchor.constraintEqualToConstant(Dimensions.size),
      colorWheel.topAnchor.constraintEqualToAnchor(topAnchor),
      colorWheel.leftAnchor.constraintEqualToAnchor(leftAnchor),

      overlay.widthAnchor.constraintEqualToConstant(Dimensions.size - Dimensions.border * 2),
      overlay.heightAnchor.constraintEqualToConstant(Dimensions.size - Dimensions.border * 2),
      overlay.centerXAnchor.constraintEqualToAnchor(colorWheel.centerXAnchor),
      overlay.centerYAnchor.constraintEqualToAnchor(colorWheel.centerYAnchor),

      indicatorOverlay.widthAnchor.constraintEqualToConstant(Dimensions.indicatorOverlay),
      indicatorOverlay.heightAnchor.constraintEqualToConstant(Dimensions.indicatorOverlay),
      indicatorOverlay.leftAnchor.constraintEqualToAnchor(colorWheel.leftAnchor,
        constant: (Dimensions.border - Dimensions.indicatorOverlay) / 2),
      indicatorOverlay.centerYAnchor.constraintEqualToAnchor(colorWheel.centerYAnchor),

      indicator.widthAnchor.constraintEqualToConstant(Dimensions.indicator),
      indicator.heightAnchor.constraintEqualToConstant(Dimensions.indicator),
      indicator.centerXAnchor.constraintEqualToAnchor(indicatorOverlay.centerXAnchor),
      indicator.centerYAnchor.constraintEqualToAnchor(indicatorOverlay.centerYAnchor),

      imageView.widthAnchor.constraintEqualToConstant(Dimensions.imageWidth),
      imageView.heightAnchor.constraintEqualToConstant(Dimensions.imageHeight),
      imageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
      imageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor)
      ])
  }

  // MARK: - Helper methods

  func createWheel() -> CGImageRef? {
    let dimension: CGFloat = Dimensions.size
    let bufferLength: Int = Int(dimension * dimension * 4)
    let bitmapData: CFMutableDataRef = CFDataCreateMutable(nil, 0)

    CFDataSetLength(bitmapData, CFIndex(bufferLength))

    let bitmap = CFDataGetMutableBytePtr(bitmapData)
    let final = Int(Dimensions.size)

    for x in 0 ..< final {
      for y in 0 ..< final {
        let point = CGPoint(x: CGFloat(x), y: CGFloat(y))
        var hsv: HSV = (hue: 0, saturation: 0, brightness: 0, alpha: 0)
        var rgb: RGB = (red: 0, green: 0, blue: 0, alpha: 0)

        let color = saturation(point)
        let saturate = color.saturation

        if saturate < 1 {
          let alpha: CGFloat = saturate > 0.992 ? (1 - saturate) * 100 : 1

          hsv = (hue: color.hue, saturation: saturate, brightness: 1, alpha: alpha)
          rgb = convertHSV(hsv)
        }

        let offset = Int(4 * (point.x + point.y * Dimensions.size))
        bitmap[offset] = UInt8(rgb.red * 255)
        bitmap[offset + 1] = UInt8(rgb.green * 255)
        bitmap[offset + 2] = UInt8(rgb.blue * 255)
        bitmap[offset + 3] = UInt8(rgb.alpha * 255)
      }
    }

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let dataProvider = CGDataProviderCreateWithCFData(bitmapData)
    let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.ByteOrderDefault.rawValue | CGImageAlphaInfo.Last.rawValue)
    let reference = CGImageCreate(final, final, 8, 32, final * 4,
                                  colorSpace, bitmapInfo, dataProvider, nil,
                                  false, .RenderingIntentDefault)

    return reference
  }

  func saturation(position: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {
    let dimension = Dimensions.size / 2
    let diferentialX = CGFloat(position.x - dimension) / dimension
    let diferentialY = CGFloat(position.y - dimension) / dimension
    let saturation = sqrt(CGFloat(diferentialX * diferentialX + diferentialY * diferentialY))
    let expression = acos(diferentialX / saturation) / CGFloat(M_PI) / 2
    let hue = saturation == 0 ? 0 : diferentialY < 0 ? 1 - expression : expression

    return (hue, saturation)
  }

//  func point(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGPoint {
//    let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
//    let hue = UIColor.getHue(color)
//    let dimension = Dimensions.size / 2
//    let diferentialX = CGFloat(position.x - dimension) / dimension
//    let diferentialY = CGFloat(position.y - dimension) / dimension
//    let saturation = sqrt(CGFloat(diferentialX * diferentialX + diferentialY * diferentialY))
//    let expression = acos(diferentialX / saturation) / CGFloat(M_PI) / 2
//    let hue = saturation == 0 ? 0 : diferentialY < 0 ? 1 - expression : expression
//
//    return (hue, saturation)
//  }

  func convertHSV(initial: HSV) -> RGB {
    var color: RGB = (red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)

    let i = Int(initial.hue * 6)
    let f = initial.hue * 6 - CGFloat(i)
    let p = initial.brightness * (1 - initial.saturation)
    let q = initial.brightness * (1 - f * initial.saturation)
    let t = initial.brightness * (1 - (1 - f) * initial.saturation)

    switch (i % 6) {
    case 0: color.red = initial.brightness; color.green = t; color.blue = p; break;
    case 1: color.red = q; color.green = initial.brightness; color.blue = p; break;
    case 2: color.red = p; color.green = initial.brightness; color.blue = t; break;
    case 3: color.red = p; color.green = q; color.blue = initial.brightness; break;
    case 4: color.red = t; color.green = p; color.blue = initial.brightness; break;
    case 5: color.red = initial.brightness; color.green = p; color.blue = q; break;
    default: color.red = initial.brightness; color.green = t; color.blue = p;
    }

    color.alpha = initial.alpha

    return color
  }
}

extension EditingView: UIGestureRecognizerDelegate {

  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
