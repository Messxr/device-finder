//
//  SettingsViewController.swift
//  Bluetooth
//
//  Created by Даниил Марусенко on 30.01.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    let manageUI = ManageUI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageUI.manageView(rateButton)
        manageUI.manageView(supportButton)
        manageUI.manageView(privacyPolicyButton)
    }
    
    @IBAction func rateButtonPressed(_ sender: UIButton) {
        Store.rateApp()
    }
    
    @IBAction func supportButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func privacyPolicyPressed(_ sender: UIButton) {
        if let url = URL(string: "") {
            UIApplication.shared.open(url)
        }
    }
    
}

