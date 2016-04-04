import UIKit
import Sugar

struct Locker {

  static let defaults = NSUserDefaults.standardUserDefaults()

  struct Key {
    static let id = "id"
    static let status = "status"
    static let intensity = "intensity"
    static let red = "red"
    static let green = "green"
    static let blue = "blue"
    static let controllerID = "controller_id"
    static let token = "controller_token"
    static let light = "light"
    private static let exist = "exist"
  }

  static func save(light: JSONDictionary) {
    defaults.bool(true, key: Key.exist)

    guard var fire = defaults.objectForKey(Key.light) as? [String : AnyObject] else {
      defaults.object(light, key: Key.light)
      return
    }

    for (key, value) in light {
      fire[key] = value
    }

    defaults.object(fire, key: Key.light)
  }

  static func controller(id: Int) {
    defaults.integer(id, key: Key.controllerID)
  }

  static func controller() -> Int {
    return defaults.integerForKey(Key.controllerID)
  }

  static func token(token: String) {
    defaults.object(token, key: Key.token)
  }

  static func token() -> String {
    return defaults.stringForKey(Key.token) ?? ""
  }

  static func light() -> LightViewModel? {
    guard defaults.boolForKey(Key.exist) else { return nil }
    
    if let JSON = defaults.objectForKey(Key.light) as? [String : AnyObject] {
      let light = Light(JSON: JSON)
      return light.viewModel()
    }

    return nil
  }

  static func clear() {
    guard let domain = NSBundle.mainBundle().bundleIdentifier else { return }
    defaults.removePersistentDomainForName(domain)
  }

  static func object<T>(type: T, _ key: String) -> T? {
    guard defaults.boolForKey(Key.exist) else { return nil }

    if let value = defaults.boolForKey(key) as? T where T.self == Bool.self {
      return value
    } else if let value = defaults.integerForKey(key) as? T where T.self == Int.self {
      return value
    } else if let value = defaults.floatForKey(key) as? T where T.self == Float.self {
      return value
    } else if let value = defaults.stringForKey(key) as? T where T.self == String.self {
      return value
    } else {
      return nil
    }
  }
}

extension NSUserDefaults {

  func object(value: AnyObject?, key: String) {
    setObject(value, forKey: key)
  }

  func bool(value: AnyObject?, key: String) {
    if let value = value as? Bool {
      setBool(value, forKey: key)
    }
  }

  func integer(value: AnyObject?, key: String) {
    if let value = value as? Int {
      setInteger(value, forKey: key)
    }
  }

  func float(value: AnyObject?, key: String) {
    if let value = value as? Float {
      setFloat(value, forKey: key)
    }
  }

  func string(value: AnyObject?, key: String) {
    if let value = value as? String {
      setObject(value, forKey: key)
    }
  }
}
