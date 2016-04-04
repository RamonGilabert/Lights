import UIKit
import Sugar


class Light {

  var id: Int
  var status: Bool
  var intensity: CGFloat
  var red: CGFloat
  var green: CGFloat
  var blue: CGFloat
  var controllerID: Int

  init(JSON: JSONDictionary) {
    id           = JSON[Locker.Key.id] as? Int ?? -1
    status       = JSON[Locker.Key.status] as? Bool ?? false
    intensity    = JSON[Locker.Key.intensity] as? CGFloat ?? 0
    red          = JSON[Locker.Key.red] as? CGFloat ?? 0
    green        = JSON[Locker.Key.green] as? CGFloat ?? 0
    blue         = JSON[Locker.Key.blue] as? CGFloat ?? 0
    controllerID = JSON[Locker.Key.controllerID] as? Int ?? 0
  }

  func viewModel() -> LightViewModel {
    return LightViewModel(
      id: id, status: status, intensity: intensity,
      red: red, green: green, blue: blue, controllerID: controllerID)
  }
}

struct LightViewModel {

  var id: Int
  var status: Bool
  var intensity: CGFloat
  var red: CGFloat
  var green: CGFloat
  var blue: CGFloat
  var controllerID: Int
}
