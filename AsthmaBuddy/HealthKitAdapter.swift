    //
//  HealthKitAdapter.swift
//  AsthmaBuddy
//
//  Created by Igor Kantor on 7/17/17.
//  Copyright © 2017 Igorware. All rights reserved.
//

import UIKit
import HealthKit
import MapKit

    
// Wrap HealthKit in HealthKitAdapter
    
class HealthKitAdapter: NSObject {

    static let sharedInstance = HealthKitAdapter()
    
    private let healthKitStore = HKHealthStore()
    
    override init() {
        
//      I. Authorization
        
//        let typesToShare : Set = [inhalerUsageQuantitityType]
//        let typesToRead : Set = [inhalerUsageQuantitityType, dobCharacteristicType, genderCharacteristicType]
//
//        if(HKHealthStore.isHealthDataAvailable()){
//            self.healthKitStore.requestAuthorization(toShare: typesToShare, read: typesToRead) {success, error in
//                let hkReadyNotif = Notification(name: .healthKitReady, object: nil)
//                NotificationCenter.default.post(hkReadyNotif)
//            }
//        }
    }
    
    func getDemograhics(completion: @escaping DemographicsCompletionBlock) {
//        II. Get Characteristics
        
//        do {
//            let dob = try healthKitStore.dateOfBirthComponents().date!
//            let gender = try healthKitStore.biologicalSex()
//            completion(dob, gender.biologicalSex)
//        } catch  {
//            print("Error")
//        }
    }
    
    func recordUsage(withLocation location:CLLocation?){
//      III. Save samples
        
//        let date = Date()
//        
//        if let location = location {
//            let lat = location.coordinate.latitude
//            let lon = location.coordinate.longitude
//            
//            // III. Save samples with location
//            
//            let coordinateString = "\(lat),\(lon)"
//
//            let sample = HKQuantitySample(
//                type: inhalerUsageQuantitityType,
//                quantity: quantityOne,
//                start: date,
//                end: date,
//                metadata: [usageLocationKey:coordinateString]
//            )
//
//            healthKitStore.save(sample) { (success, error) in
//                print("saved one use to health kit, with location")
//            }
//        }
//        else {
//            
//            //      III. Save samples
//
//            let sample = HKQuantitySample(
//                type: inhalerUsageQuantitityType,
//                quantity: quantityOne,
//                start: date,
//                end: date
//            )
//            
//            healthKitStore.save(sample) { (success, error) in
//                print("saved one use to health kit")
//            }
//        }
    }
    
    func getInhalerUsage(completion: @escaping InhalerUsageCompletionBlock){
//  IV: Get data for chart and map
        
//        let query = HKSampleQuery(
//            sampleType: inhalerUsageQuantitityType,
//            predicate: nil,
//            limit: 100,
//            sortDescriptors: nil) { (query, samples, error) in
//                completion(samples as? [HKQuantitySample])
//            }
//
//        self.healthKitStore.execute(query)
    }
}
