import UIKit

struct Text {

  struct Explanation {
    static let title = "Lights".uppercaseString
    static let subtitle = "Lights will let you control your lamps from anywhere in the world. Pair your device and start controlling.".uppercaseString
  }

  struct Detail {
    static let searching = "Searching".uppercaseString
    static let offline = "You seem to be offline".uppercaseString
  }

  struct Pairing {
    static let found = "1 light found".uppercaseString
    static let pairing = "Pairing".uppercaseString
    static let paired = "Paired".uppercaseString
    static let control = "You can now control your lights from anywhere, change the intensity or even the color of the bulb.".uppercaseString
    static let use = "Start using".uppercaseString
  }

  struct Editing {
    static let turnOn = "Turn on".uppercaseString
    static let turnOff = "Turn off".uppercaseString
  }

  struct Bluetooth {
    static let title = "Bluetooth"
    static let button = "All right"
    static let unauthorized = "You don't have the app authorized to use the bluetooth devices."
    static let powered = "Try turning the bluetooth on and starting the process again."
    static let unknown = "There was an unknown problem, try it again later."
  }
}
