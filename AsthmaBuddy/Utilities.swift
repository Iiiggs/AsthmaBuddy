//
//  Utilities.swift
//  AsthmaBuddy
//
//  Created by Igor Kantor on 8/7/17.
//  Copyright © 2017 Igorware. All rights reserved.
//

import Foundation
import HealthKit
import UIKit
import MapKit


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

            let tadays_samples = self.filter {
                $0.startDate > currentDate && $0.startDate < tomorrow
            }
            
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
