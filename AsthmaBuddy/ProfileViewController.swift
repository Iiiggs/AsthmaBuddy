//
//  TrackViewController.swift
//  AsthmaBuddy
//
//  Created by Igor Kantor on 7/18/17.
//  Copyright © 2017 Igorware. All rights reserved.
//

import UIKit
import CoreLocation

class ProfileViewController: UIViewController, BaseHealthKitViewControllerProtocol {
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        
    }
    
    func requestLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
    }
    
    
    
    func healthKitReady() {
        // use the adapter to get things
        print("healthKitReady")
    }
    
    @IBAction func trackUsage(_ sender: Any) {
        requestLocation()
    }
    
    func saveUsage(location:CLLocation){
        HealthKitAdapter.sharedInstance.recordUsage(withLocation:location)
    }
    
    // todo: add button for:
    //        HealthKitAdapter.sharedInstance.createSampleData()
}

extension ProfileViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        HealthKitAdapter.sharedInstance.recordUsage()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            HealthKitAdapter.sharedInstance.recordUsage()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // todo: check for error and save without
        let location = locations[0]
        self.saveUsage(location: location)
    }
}
