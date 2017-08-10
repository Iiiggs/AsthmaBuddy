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

class HealthKitAdapter: NSObject {

    static let sharedInstance = HealthKitAdapter()
    
    private let healthKitStore = HKHealthStore()
    

    override init() {
        
//        [STEP 1]: Authorization
        let typesToShare : Set = [inhalerUsageQuantitityType]
        let typesToRead : Set = [inhalerUsageQuantitityType, dobCharacteristicType, genderCharacteristicType]

        if(HKHealthStore.isHealthDataAvailable()){
            self.healthKitStore.requestAuthorization(toShare: typesToShare, read: typesToRead, completion: { (success, error) in
                let hkReadyNotif = Notification(name: .healthKitReady, object: nil)
                // get some data
                NotificationCenter.default.post(hkReadyNotif)
            })
        }
    }
    
    func getDemograhics(completion: @escaping DemographicsCompletionBlock) {
//        [STEP 2]: Characteristic types
//          do {
//            let dob = try healthKitStore.dateOfBirthComponents().date!
//            let gender = try healthKitStore.biologicalSex()
//            completion(dob, gender.biologicalSex)
//        } catch  {
//            print("Error")
//        }
    }
    
    func recordUsage(withLocation location:CLLocation?){ // pass in a competion block
//        [STEP 3]: Save samples
//        let date = Date()
//        
//        if let location = location {
//            let coordinateString = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
//            
//            let sample = HKQuantitySample(
//                type: HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.inhalerUsage)!,
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
//            let sample = HKQuantitySample(
//                type: HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.inhalerUsage)!,
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
//        [STEP 5]: Get data for chart and map
//        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.inhalerUsage)!
//        let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: 100, sortDescriptors: nil) { (query, samples, error) in
//            completion(samples as? [HKQuantitySample])
//        }
//        
//        self.healthKitStore.execute(query)
    }
}
