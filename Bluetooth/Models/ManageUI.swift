//
//  ManageUI.swift
//  Bluetooth
//
//  Created by Даниил Марусенко on 21.04.2021.
//

import UIKit

struct ManageUI {
    
    func manageView(_ view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 3
    }
    
}
