//
//  TrackViewController.swift
//  AsthmaBuddy
//
//  Created by Igor Kantor on 7/18/17.
//  Copyright © 2017 Igorware. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit

// [X] Wire up dob and gender
// [X] add tint and selected styling to inhalerUsed button
// [X] fix so we only post one usage - didUpdateLoccatinos called multiple times
// [X] check for didUpdateLocation error and save without location
// [ ] add button for creating sample data: HealthKitAdapter.sharedInstance.createSampleData()
// [ ] deal with no location services or denied gracefully


class ProfileViewController: UIViewController, BaseHealthKitViewControllerProtocol {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!

    let locationManager = CLLocationManager()
    var gettingLocation  = false
    
    
    func requestLocation(){
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.distanceFilter = 100.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        gettingLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDemographics()
    }
    
    func healthKitReady() {
        loadDemographics()
    }
    
    func loadDemographics(){
        HealthKitAdapter.sharedInstance.getDemograhics { (dob, gender) in
            let age = NSCalendar.current.dateComponents([.year], from: dob, to: Date()).year!
            
            switch gender {
            case .male:
                self.genderLabel.text = "Male"
            case .female:
                self.genderLabel.text = "Female"
            case .other:
                self.genderLabel.text = "Other"
            case .notSet:
                self.genderLabel.text = "Not Set"
            }
            
            self.ageLabel.text = age.description
        }
    }
    
    @IBAction func trackUsage(_ sender: Any) {
        requestLocation()
    }
    
    func saveUsage(location:CLLocation?){
        HealthKitAdapter.sharedInstance.recordUsage(withLocation:location)
    }
}

extension ProfileViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        if (gettingLocation){
            gettingLocation = false
            self.saveUsage(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        self.saveUsage(location: nil)
    }
}
