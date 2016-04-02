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
    private static let exist = "exist"
  }

  static func save(light: JSONDictionary) {
    defaults.bool(true, key: Key.exist)
    defaults.integer(light[Key.id], key: Key.id)
    defaults.bool(light[Key.status], key: Key.status)
    defaults.float(light[Key.intensity], key: Key.intensity)
    defaults.float(light[Key.red], key: Key.red)
    defaults.float(light[Key.green], key: Key.green)
    defaults.float(light[Key.blue], key: Key.blue)
    defaults.integer(light[Key.controllerID], key: Key.controllerID)
  }

  static func object<T>(type: T, _ key: String) -> T? {
    guard defaults.boolForKey(Key.exist) else { return nil }

    if let value = defaults.boolForKey(key) as? T where T.self == Bool.self {
      return value
    } else if let value = defaults.integerForKey(key) as? T where T.self == Int.self {
      return value
    } else if let value = defaults.floatForKey(key) as? T where T.self == Float.self {
      return value
    } else {
      return nil
    }
  }
}

extension NSUserDefaults {

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
}
