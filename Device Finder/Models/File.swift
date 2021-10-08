//
//  File.swift
//  Bluetooth
//
//  Created by Даниил Марусенко on 21.04.2021.
//

import Foundation
import StoreKit

struct Store {
    
    static func rateApp() {
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
}
