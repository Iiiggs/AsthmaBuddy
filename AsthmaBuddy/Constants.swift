//
//  Constants.swift
//  AsthmaBuddy
//
//  Created by Igor Kantor on 8/7/17.
//  Copyright © 2017 Igorware. All rights reserved.
//

import Foundation
import HealthKit

let inhalerUsageQuantitityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.inhalerUsage)!
let genderCharacteristicType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!
let dobCharacteristicType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!

HKDocumentTypeIdentifier.CDA

let categoryType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.)

let quantityOne = HKQuantity(unit:HKUnit.count(), doubleValue:1.0)

typealias InhalerUsageCompletionBlock = (([HKQuantitySample]?) -> Void)
typealias DemographicsCompletionBlock = ((Date, HKBiologicalSex) -> Void)

let usageLocationKey = "UsageLocation"

extension Notification.Name {
    static let healthKitReady = Notification.Name("com.igorware.healthKitReadyKey")
}

@objc protocol BaseHealthKitViewControllerProtocol {
    func healthKitReady()
}


