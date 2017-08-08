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


// [ ] move extensions somewhere?
    


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
          do {
            let dob = try healthKitStore.dateOfBirthComponents().date!
            let gender = try healthKitStore.biologicalSex()
            completion(dob, gender.biologicalSex)
        } catch  {
            print("Error")
        }
    }
    
    func recordUsage(withLocation location:CLLocation?){ // pass in a competion block
//        [STEP 3]: Save samples
        let date = Date()
        
        if let location = location {
            let coordinateString = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
            
            let sample = HKQuantitySample(
                type: HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.inhalerUsage)!,
                quantity: quantityOne,
                start: date,
                end: date,
                metadata: [usageLocationKey:coordinateString]
            )
            
            healthKitStore.save(sample) { (success, error) in
                print("saved one use to health kit, with location")
            }
        }
        else {
            let sample = HKQuantitySample(
                type: HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.inhalerUsage)!,
                quantity: quantityOne,
                start: date,
                end: date
            )
            
            healthKitStore.save(sample) { (success, error) in
                print("saved one use to health kit")
            }
        }
    }
    
    func getInhalerUsage(completion: @escaping InhalerUsageCompletionBlock){
//        [STEP 5]
//        // for map and trends chart
//        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.inhalerUsage)!
//        let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: 100, sortDescriptors: nil) { (query, samples, error) in
//            completion(samples as? [HKQuantitySample])
//        }
//        
//        self.healthKitStore.execute(query)
    }
}
    
    


extension Array {
    func group<T>(by criteria: (Element) -> T) -> [T: [Element]] {
        var groups = [T: [Element]]()
        for element in self {
            let key = criteria(element)
            if groups.keys.contains(key) == false {
                groups[key] = [Element]()
            }
            groups[key]?.append(element)
        }
        return groups
    }
}
    
    
// MARK: - Array<HKQuantitySample> countByDate
extension Array where  Iterator.Element == HKQuantitySample {
    func sampleValueCountByDate(start:Date, end:Date) -> [Date: Double] {
        var currentDate = start
        
        var result = [Date : Double] ()
        while(currentDate <= end){
            let tomorrow = NSCalendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            let tadays_samples =  self.filter({ (s) -> Bool in s.startDate > currentDate && s.startDate < tomorrow }) // todo: shorten syntax
            let sum = tadays_samples.reduce(0.0, { (r, sample) -> Double in
                let sum : Double = r
                let value : Double = sample.quantity.doubleValue(for:HKUnit.count())

                return value + sum
            })

            
            result[currentDate] = sum
            currentDate = tomorrow
        }
        
        return result
    }
    
    func sampleLocations(start:Date, end:Date) -> [HKQuantitySample] {
        return self.filter { (s) -> Bool in s.startDate > start && s.endDate < end && s.metadata?[usageLocationKey] != nil}
    }
}
    
// MARK: - HKQantitySample implements MKAnnotation
extension HKQuantitySample : MKAnnotation {
    public var title: String? {
        return "\(self.quantityType)"
    }
    
    public var coordinate: CLLocationCoordinate2D {
        if let location = self.metadata?[usageLocationKey] as? String{
            let coordinate = location.components(separatedBy: ",")
            
            return CLLocationCoordinate2D(latitude: Double(coordinate[0])!, longitude: Double(coordinate[1])!)
        } else {
            return CLLocationCoordinate2D(latitude: 39.570154341901485, longitude: -105.30286789781341) 
        }
    }
    
    // pinTintColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    func pinTintColor() -> UIColor  {
        return UIColor.brown
    }
    
    // annotation callout opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = title
        
        return mapItem
    }
}



    
