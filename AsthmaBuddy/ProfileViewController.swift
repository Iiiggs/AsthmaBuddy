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

// [ ] fix so we only post one usage - didUpdateLoccatinos called multiple times
// [ ] add button for creating sample data: HealthKitAdapter.sharedInstance.createSampleData()
// [ ] check for didUpdateLocation error and save without location


class ProfileViewController: UIViewController, BaseHealthKitViewControllerProtocol {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDemographics()
    }
    
    func requestLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
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
    
    func saveUsage(location:CLLocation){
        HealthKitAdapter.sharedInstance.recordUsage(withLocation:location)
    }
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
        let location = locations[0]
        self.saveUsage(location: location)
    }
}
