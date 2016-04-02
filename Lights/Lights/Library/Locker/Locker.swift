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
    guard var fire = defaults.objectForKey(Key.light) as? [String : AnyObject] else { return }

    for (key, value) in light {
      fire[key] = value
    }

    defaults.object(fire, key: Key.light)
  }

  static func token(token: String) {
    guard var fire = defaults.objectForKey(Key.light) as? [String : AnyObject] else {
      defaults.object([Key.token : token], key: Key.token)

      return
    }

    fire[Key.token] = token
    defaults.object(fire, key: Key.token)
  }

  static func light() -> [String : AnyObject]? {
    guard defaults.boolForKey(Key.exist) else { return nil }
    
    return defaults.objectForKey(Key.token) as? [String : AnyObject]
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
