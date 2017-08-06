//
//  TrackViewController.swift
//  AsthmaBuddy
//
//  Created by Igor Kantor on 7/18/17.
//  Copyright © 2017 Igorware. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, BaseHealthKitViewControllerProtocol {
    
    func healthKitReady() {
        // use the adapter to get things
        print("healthKitReady")
    }
    
    @IBAction func trackUsage(_ sender: Any) {
        HealthKitAdapter.sharedInstance.recordUsage()
        
//        HealthKitAdapter.sharedInstance.createSampleData()
    }

}
