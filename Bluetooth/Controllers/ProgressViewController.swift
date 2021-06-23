//
//  ProgressViewController.swift
//  Bluetooth
//
//  Created by Даниил Марусенко on 29.01.2021.
//

import UIKit
import MBCircularProgressBar
import CoreBluetooth
import RealmSwift

class ProgressViewController: UIViewController {

    @IBOutlet weak var foundButton: UIButton!
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var deleteButton: UIButton!
    
    let realm = try! Realm()
    var centralManager: CBCentralManager!
    var peripheralName: String?
    var peripheralDistance: String?
    let manageUI = ManageUI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.isHidden = true
        let devices = realm.objects(Device.self)
        for device in devices {
            if device.name == peripheralName {
                deleteButton.isHidden = false
            }
        }

        manageUI.manageView(foundButton)
        manageUI.manageView(containerView)
        
        progressView.value = 0
        centralManager = CBCentralManager(delegate: self, queue: nil)
        self.title = peripheralName
    }
    
    @IBAction func foundPressed(_ sender: UIButton) {
        Store.rateApp()
    }
    
    @IBAction func myDevicePressed(_ sender: UIButton) {
        let newDevice = Device()
        if let name = peripheralName {
            newDevice.name = name
        }
        realm.beginWrite()
        realm.add(newDevice)
        try! realm.commitWrite()
        
        performAlert(message: "This device has been added to my devices")
        deleteButton.isHidden = false
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        let devices = realm.objects(Device.self)
        for device in devices {
            if device.name == peripheralName {
                try! realm.write {
                    realm.delete(device)
                }
            }
        }
        performAlert(message: "This device has been deleted from my devices")
        deleteButton.isHidden = true
    }
    
    func performAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - CoreBluetooth

extension ProgressViewController:  CBCentralManagerDelegate, CBPeripheralDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name {
            let distance = pow(10, ((-69-Double(truncating: RSSI))/(10*2)))*3.2808
            if distance <= 15 {
                if name == peripheralName {
                    UIView.animate(withDuration: 1.0) {
                        self.progressView.value = CGFloat(100 - distance / 0.15)
                    }
                }
            }
        }
    }

    
}

