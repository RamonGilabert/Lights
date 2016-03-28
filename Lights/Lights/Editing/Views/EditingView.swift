import UIKit

class EditingView: UIView {

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
    wheelLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    wheelLayer.contents = createWheel()
    colorWheel.layer.addSublayer(wheelLayer)

    colorWheel.frame = CGRect(x: 0, y: 0, width: 300, height: 300)

    addSubview(colorWheel)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Helper methods

  typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
  typealias HSV = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)

  func createWheel() -> CGImageRef? {
    let size = CGSize(width: 300, height: 300)

    let originalWidth: CGFloat = size.width
    let originalHeight: CGFloat = size.height
    let dimension: CGFloat = min(originalWidth, originalHeight)
    let bufferLength: Int = Int(dimension * dimension * 4)

    let bitmapData: CFMutableDataRef = CFDataCreateMutable(nil, 0)
    CFDataSetLength(bitmapData, CFIndex(bufferLength))
    let bitmap = CFDataGetMutableBytePtr(bitmapData)

    for (var y: CGFloat = 0; y < dimension; y++) {
      for (var x: CGFloat = 0; x < dimension; x++) {
        var hsv: HSV = (hue: 0, saturation: 0, brightness: 0, alpha: 0)
        var rgb: RGB = (red: 0, green: 0, blue: 0, alpha: 0)

        let color = hueSaturationAtPoint(CGPointMake(x, y))
        let hue = color.hue
        let saturation = color.saturation
        var a: CGFloat = 0.0
        if (saturation < 1.0) {
          // Antialias the edge of the circle.
          if (saturation > 0.99) {
            a = (1.0 - saturation) * 100
          } else {
            a = 1.0;
          }

          hsv.hue = hue
          hsv.saturation = saturation
          hsv.brightness = 1.0
          hsv.alpha = a
          rgb = hsv2rgb(hsv)
        }
        let offset = Int(4 * (x + y * dimension))
        bitmap[offset] = UInt8(rgb.red*255)
        bitmap[offset + 1] = UInt8(rgb.green*255)
        bitmap[offset + 2] = UInt8(rgb.blue*255)
        bitmap[offset + 3] = UInt8(rgb.alpha*255)
      }
    }

    // Convert the bitmap to a CGImage
    let colorSpace: CGColorSpaceRef? = CGColorSpaceCreateDeviceRGB()
    let dataProvider: CGDataProviderRef? = CGDataProviderCreateWithCFData(bitmapData)
    let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.ByteOrderDefault.rawValue | CGImageAlphaInfo.Last.rawValue)
    let imageRef: CGImageRef? = CGImageCreate(Int(dimension), Int(dimension), 8, 32, Int(dimension) * 4, colorSpace, bitmapInfo, dataProvider, nil, false, CGColorRenderingIntent.RenderingIntentDefault)
    return imageRef
  }

  func hueSaturationAtPoint(position: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {
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

  func hsv2rgb(hsv: HSV) -> RGB {
    // Converts HSV to a RGB color
    var rgb: RGB = (red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat

    let i = Int(hsv.hue * 6)
    let f = hsv.hue * 6 - CGFloat(i)
    let p = hsv.brightness * (1 - hsv.saturation)
    let q = hsv.brightness * (1 - f * hsv.saturation)
    let t = hsv.brightness * (1 - (1 - f) * hsv.saturation)
    switch (i % 6) {
    case 0: r = hsv.brightness; g = t; b = p; break;

    case 1: r = q; g = hsv.brightness; b = p; break;

    case 2: r = p; g = hsv.brightness; b = t; break;

    case 3: r = p; g = q; b = hsv.brightness; break;

    case 4: r = t; g = p; b = hsv.brightness; break;

    case 5: r = hsv.brightness; g = p; b = q; break;

    default: r = hsv.brightness; g = t; b = p;
    }

    rgb.red = r
    rgb.green = g
    rgb.blue = b
    rgb.alpha = hsv.alpha
    return rgb
  }

}
