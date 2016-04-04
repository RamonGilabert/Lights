import UIKit
import CoreBluetooth
import Sugar

var bluetooth = Bluetooth()

protocol BluetoothDelegate {

  func shouldShowMessage(message: String)
}

class Bluetooth: NSObject {

  private var centralManager: CBCentralManager?
  private var peripheralBLE: CBPeripheral?
  var delegate: BluetoothDelegate?

  override init() {
    super.init()

    let queue = dispatch_queue_create("no.bluetooth", DISPATCH_QUEUE_SERIAL)
    centralManager = CBCentralManager(delegate: self, queue: queue)
  }

  func scan() {
    guard let central = centralManager else { return }
    central.scanForPeripheralsWithServices(nil, options: nil)
  }
}

extension Bluetooth: CBCentralManagerDelegate {

  func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
    print(peripheral)
  }

  func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
    print(peripheral)
  }

  func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
    print(peripheral)
  }

  func centralManagerDidUpdateState(central: CBCentralManager) {
    var message = ""

    switch central.state {
    case .Unauthorized:
      message = Text.Bluetooth.unauthorized
    case .PoweredOff:
      message = Text.Bluetooth.powered
    case .PoweredOn:
      scan(); return
    default:
      message = Text.Bluetooth.unknown
    }

    delegate?.shouldShowMessage(message)
  }
}

//  var bleService: BTService? {
//    didSet {
//      if let service = self.bleService {
//        service.startDiscoveringServices()
//      }
//    }
//  }

//  // MARK: - CBCentralManagerDelegate
//
//  func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
//    // Be sure to retain the peripheral or it will fail during connection.
//
//    // Validate peripheral information
//    if ((peripheral.name == nil) || (peripheral.name == "")) {
//      return
//    }
//
//    // If not already connected to a peripheral, then connect to this one
//    if ((self.peripheralBLE == nil) || (self.peripheralBLE?.state == CBPeripheralState.Disconnected)) {
//      // Retain the peripheral before trying to connect
//      self.peripheralBLE = peripheral
//
//      // Reset service
//      self.bleService = nil
//
//      // Connect to peripheral
//      central.connectPeripheral(peripheral, options: nil)
//    }
//  }
//
//  func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
//
//    // Create new service class
//    if (peripheral == self.peripheralBLE) {
//      self.bleService = BTService(initWithPeripheral: peripheral)
//    }
//
//    // Stop scanning for new devices
//    central.stopScan()
//  }
//
//  func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
//
//    // See if it was our peripheral that disconnected
//    if (peripheral == self.peripheralBLE) {
//      self.bleService = nil;
//      self.peripheralBLE = nil;
//    }
//
//    // Start scanning for new devices
//    self.startScanning()
//  }
//
//  // MARK: - Private
//
//  func clearDevices() {
//    self.bleService = nil
//    self.peripheralBLE = nil
//  }
//
//  func centralManagerDidUpdateState(central: CBCentralManager) {
//    switch (central.state) {
//    case CBCentralManagerState.PoweredOff:
//      self.clearDevices()
//
//    case CBCentralManagerState.Unauthorized:
//      // Indicate to user that the iOS device does not support BLE.
//      break
//
//    case CBCentralManagerState.Unknown:
//      // Wait for another event
//      break
//
//    case CBCentralManagerState.PoweredOn:
//      self.startScanning()
//
//    case CBCentralManagerState.Resetting:
//      self.clearDevices()
//
//    case CBCentralManagerState.Unsupported:
//      break
//    }
//  }
//
//}
