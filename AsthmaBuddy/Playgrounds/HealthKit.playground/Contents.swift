//: Playground - noun: a place where people can play

import UIKit
import HealthKit

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
let startDate = dateFormatter.date(from: "08/09/2017 10:00")!
let endDate = dateFormatter.date(from: "08/09/2017 12:00")!


let types : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.inhalerUsage)!]


// HKHealthStore



//if (HKHealthStore.isHealthDataAvailable()) {
//    let healthStore = HKHealthStore()
//    healthStore.requestAuthorization(
//        toShare: types,
//        read: types)
//        {_,_ in print("check response")}
    
//}



// HKObjectType 

let dobType = HKObjectType.characteristicType(forIdentifier:
    HKCharacteristicTypeIdentifier.dateOfBirth)

let activitySummaryType = HKObjectType.activitySummaryType()

let inhalerUsageType = HKObjectType.quantityType(forIdentifier:
    HKQuantityTypeIdentifier.inhalerUsage)


// HKCharacteristicType

let genderType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)

let bloodType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)

let fitzpatrickSkinType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.fitzpatrickSkinType)


// HKSampleType

let categoryType = HKObjectType.categoryType(
    forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)

let correlationType = HKObjectType.correlationType(
    forIdentifier: HKCorrelationTypeIdentifier.bloodPressure)

let stepsType = HKObjectType.quantityType(
    forIdentifier: HKQuantityTypeIdentifier.stepCount)!

let documentType = HKObjectType.documentType(
    forIdentifier: HKDocumentTypeIdentifier.CDA)


// HKSample

let tenThousandSteps = HKQuantity(
    unit: HKUnit.count(),
    doubleValue: 10_000.0)

let stepsSample = HKQuantitySample(
    type: stepsType,
    quantity: tenThousandSteps,
    start:startDate,
    end: endDate)

healthStore.save(stepsSample)
    { (success, error) in print("check success") }




// HKUnit

let gramUnit = HKUnit.gram()

let meterUnit = HKUnit.meter()

let kiloMeterUnit = HKUnit.meterUnit(with: HKMetricPrefix.kilo)

let hourUnit = HKUnit.hour()

// complex unit
let deciliter = HKUnit.literUnit(with: HKMetricPrefix.deci)
let decilitersPerHour = deciliter.unitDivided(by: hourUnit)


// HKQuantity
let twoGrams = HKQuantity(
    unit: gramUnit,
    doubleValue: 2.0
)

let threeMeters = HKQuantity(
    unit: meterUnit,
    doubleValue: 3.0
)

let fiveKilometers = HKQuantity(
    unit: kiloMeterUnit,
    doubleValue: 5.0
)

// HKQuantity Conversion

let feetIn5K = fiveKilometers.doubleValue(
    for: HKUnit.foot()
)

let stonesIn2Grams = twoGrams.doubleValue(
    for: HKUnit.stone()
)


let igorHeightInches = HKQuantity(unit: HKUnit.foot(), doubleValue: 6).doubleValue(for: HKUnit.inch()) + 4.0
let igorHeightMeters = HKQuantity(unit: HKUnit.inch(), doubleValue: igorHeightInches).doubleValue(for: HKUnit.meter())



// HKWorkout

let workout1 = HKWorkout(
    activityType: .basketball,
    start: startDate,
    end: endDate
)

let workout2 = HKWorkout(
    activityType: .cycling,
    start: startDate,
    end: endDate,
    workoutEvents: nil,
    totalEnergyBurned: nil,
    totalDistance: fiveKilometers,
    metadata: nil
)


// HKQuery -  
// predicate factory


// HKQuery Types

//HKAnchoredObjectQuery
//HKCorrelationQuery
//HKObserverQuery
//HKSampleQuery
//HKSourceQuery
//HKStatisticsQuery
//HKStatisticsCollectionQuery



let workoutType = HKObjectType.workoutType()

//HKSampleQuery

let runPredicate =
    HKQuery.predicateForWorkouts(with: .running)

let sampleQuery =
    HKSampleQuery(
    sampleType:workoutType ,
    predicate: runPredicate,
    limit: 100,
    sortDescriptors: nil)
    { (sampleQuery, samples, error) in print("check error")}


//HKObserverQuery

//let observer = 

//HKStatisticsCollectionQuery

var dateComponents = DateComponents()
dateComponents.day = 1

let statisticsCollectionQuery = HKStatisticsCollectionQuery(
    quantityType: stepsType,
    quantitySamplePredicate: nil,
    options: HKStatisticsOptions.cumulativeSum,
    anchorDate: startDate,
    intervalComponents: dateComponents)


    //HKAnchoredObjectQuery
    //HKCorrelationQuery

    //HKSourceQuery
    //HKStatisticsCollectionQuery


//
