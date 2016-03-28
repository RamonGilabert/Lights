import UIKit

class EditingView: UIView {

  struct Dimensions {
    static let size: CGFloat = UIScreen.mainScreen().bounds.width + LightsController.Dimensions.wheelWidth
  }

  typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
  typealias HSV = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)

  lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()

  lazy var colorWheel: UIView = {
    let view = UIView()
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    let wheelLayer = CALayer()
    wheelLayer.frame = CGRect(x: 0, y: 0, width: Dimensions.size, height: Dimensions.size)
    wheelLayer.contents = createWheel()
    colorWheel.layer.addSublayer(wheelLayer)

    [colorWheel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }

    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Constraints

  func setupConstraints() {
    NSLayoutConstraint.activateConstraints([
      colorWheel.widthAnchor.constraintEqualToAnchor(widthAnchor),
      colorWheel.heightAnchor.constraintEqualToAnchor(heightAnchor),
      colorWheel.topAnchor.constraintEqualToAnchor(topAnchor),
      colorWheel.leftAnchor.constraintEqualToAnchor(leftAnchor)
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
          let alpha: CGFloat = saturate > 0.99 ? (1 - saturate) * 100 : 1

          hsv = (hue: color.hue, saturation: saturate, brightness: 1, alpha: alpha)
          rgb = hsv2rgb(hsv)
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
    let c: CGFloat = 150
    let dx = CGFloat(position.x - c) / c
    let dy = CGFloat(position.y - c) / c
    let d = sqrt(CGFloat (dx * dx + dy * dy))

    let saturation: CGFloat = d

    var hue: CGFloat
    if (d == 0) {
      hue = 0;
    } else {
      hue = acos(dx/d) / CGFloat(M_PI) / 2.0
      if (dy < 0) {
        hue = 1.0 - hue
      }
    }
    return (hue, saturation)
  }

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
