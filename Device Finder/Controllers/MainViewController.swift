//
//  ViewController.swift
//  Bluetooth
//
//  Created by Даниил Марусенко on 27.01.2021.
//

import UIKit
import CoreBluetooth
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var centralManager: CBCentralManager!
    var dataArray: [[String]] = [[], []]
    var index: Int?
    var myDevices: [String] = []
    var myDevicesDistance = [String : String]()
    var twoSections = false
    var myDevicesTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getData()

        if myDevices.isEmpty {
            twoSections = false
        }
    }
    
    func getData() {
        myDevices = []
        let devices = realm.objects(Device.self)
        for device in devices {
            myDevices.append(device.name)
            if myDevicesDistance[device.name] == nil {
                myDevicesDistance[device.name] = "-"
            }
        }
        tableView.reloadData()
    }

    
}


//MARK: - CoreBluetooth

extension MainViewController:  CBCentralManagerDelegate, CBPeripheralDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name {
            
            let distance = String(format: "%.1f", pow(10, ((-69-Double(truncating: RSSI))/(10*2)))*3.2808)+"m"
            
            if myDevices.contains(name) {
                myDevicesDistance[name] = distance
            }
            
            if !dataArray[0].contains("\(name)") {
                dataArray[0].append("\(name)")
                dataArray[1].append(distance)
                tableView.reloadData()
            } else {
                var index = 0
                for dataName in dataArray[0] {
                    if name == dataName {
                        dataArray[1][index] = distance
                        tableView.reloadData()
                    }
                    index += 1
                }
            }
        }
    }

    
}

//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if twoSections {
            if section == 0 {
                return myDevices.count
            } else {
                return dataArray[0].count
            }
        } else {
            return dataArray[0].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        if twoSections {
            if indexPath.section == 0 {
                cell.nameLabel.text = myDevices[indexPath.row]
                cell.distanceLabel.text = myDevicesDistance[myDevices[indexPath.row]]
            } else {
                cell.nameLabel.text = dataArray[0][indexPath.row]
                cell.distanceLabel.text = dataArray[1][indexPath.row]
            }
        } else {
            cell.nameLabel.text = dataArray[0][indexPath.row]
            cell.distanceLabel.text = dataArray[1][indexPath.row]
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !myDevices.isEmpty {
            twoSections = true
            return 2
        } else {
            twoSections = false
            return 1
        }
    }
    
    
}


//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let destinationVC = segue.destination as! ProgressViewController
            if let index = self.index {
                if myDevicesTapped {
                    destinationVC.peripheralName = myDevices[index]
                    destinationVC.peripheralDistance = myDevicesDistance[myDevices[index]]
                } else {
                    destinationVC.peripheralName = dataArray[0][index]
                    destinationVC.peripheralDistance = dataArray[1][index]
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if twoSections {
            if indexPath.section == 0 {
                myDevicesTapped = true
            } else {
                myDevicesTapped = false
            }
        } else {
            myDevicesTapped = false
        }
        self.index = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if twoSections {
            if section == 0 {
                return "My devices"
            }
            if section == 1 {
                return "Near devices"
            }
        } else {
            return "Near devices"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if twoSections {
            if section == 0 {
                return nil
            }
            if section == 1 {
                return "Navigate to find nearby devices."
            }
        } else {
            return "Navigate to find nearby devices."
        }
        return nil
    }
    
}

