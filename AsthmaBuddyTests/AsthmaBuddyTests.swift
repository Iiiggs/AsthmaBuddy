//
//  AsthmaBuddyTests.swift
//  AsthmaBuddyTests
//
//  Created by Igor Kantor on 7/17/17.
//  Copyright © 2017 Igorware. All rights reserved.
//

import XCTest
import HealthKit
@testable import AsthmaBuddy


//func createSampleData() {




class AsthmaBuddyTests: XCTestCase {
    let store = HKHealthStore()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
        self.store.save(samples) { (success, error) in
            if success {
                print("Saved records to health store")
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print("Done")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
