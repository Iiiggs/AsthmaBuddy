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

let inhalerUsageQuantitityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.inhalerUsage)!
let quantityOne = HKQuantity(unit:HKUnit.count(), doubleValue:1.0)

typealias UsageCompletionBlock = (([HKQuantitySample]?) -> Void)
    
let usageLocationKey = "UsageLocation"

class HealthKitAdapter: NSObject {

    static let sharedInstance = HealthKitAdapter()
    
    private let healthKitStore = HKHealthStore()

    override init() {
        guard let inhalerUsageType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.inhalerUsage) else {
            // Precondition failure
            return
        }
        
        let typesToShare : Set<HKQuantityType> = [inhalerUsageType]
        let typesToRead : Set<HKQuantityType> = [inhalerUsageType]

        if(HKHealthStore.isHealthDataAvailable()){
            self.healthKitStore.requestAuthorization(toShare: typesToShare, read: typesToRead, completion: { (success, error) in
                let hkReadyNotif = Notification(name: .healthKitReady, object: nil)
                // get some data
                NotificationCenter.default.post(hkReadyNotif)
            })
        }
    }
    
    // save single useage
    
    func recordUsage(withLocation location:CLLocation){ // pass in a competion block
        let date = Date()
        
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
    
    func recordUsage(){
        let date = Date()
        
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
    
    // get all usages
    func getInhalerUsage(completion: @escaping UsageCompletionBlock){
        // for map and trends chart
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.inhalerUsage)!
        let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: 100, sortDescriptors: nil) { (query, samples, error) in
            completion(samples as? [HKQuantitySample])
        }
        
        self.healthKitStore.execute(query)
    }
    
    func createSampleData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        let date1 = Date()
        let date2 = NSCalendar.current.date(byAdding: .day, value: 1, to: date1)!
        let date3 = NSCalendar.current.date(byAdding: .day, value: 1, to: date2)!
        let date4 = NSCalendar.current.date(byAdding: .day, value: 1, to: date3)!
        
        let samples : [HKQuantitySample] = [HKQuantitySample.init(type: inhalerUsageQuantitityType , quantity: quantityOne, start: date1, end: date1),
                                            HKQuantitySample.init(type: inhalerUsageQuantitityType , quantity: quantityOne, start: date2, end: date2),
                                            HKQuantitySample.init(type: inhalerUsageQuantitityType , quantity: quantityOne, start: date3, end: date3),
                                            HKQuantitySample.init(type: inhalerUsageQuantitityType , quantity: quantityOne, start: date4, end: date4)]
        self.healthKitStore.save(samples) { (success, error) in
            if success {
                print("Saved records")
            } else {
                print(error.debugDescription)
            }
        }
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
//    func sampleValueCountByDate(start:Date, end:Date) -> [(String, Double)] {
//        let filtered = self.filter { (sample) -> Bool in
//            return sample.startDate > start && sample.endDate < end
//        }
//        
//        // group by date
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd"
//        
//        let grouped = filtered.group { (sample) -> String in
//            let sampleDate = sample.startDate
//            return formatter.string(from: sampleDate)
//        }
//        
//        // extract values
//        let mapped = grouped.map { (quantitiesForDate) -> (String, Double) in
//            let values = quantitiesForDate.value
//            
//            let sum = values.reduce(0.0, { (r, sample) -> Double in
//                let sum : Double = r
//                let value : Double = sample.quantity.doubleValue(for:HKUnit.count())
//                
//                return value + sum
//            })
//            
//            return (quantitiesForDate.key, sum)
//        }
//        
//        return mapped
//    }
    
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
        
        // todo: parse coordinates from metadata
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



    
