//: Playground - noun: a place where people can play

import UIKit
import HealthKit

let dateFormatter = DateFormatter()
dateFormatter.dateStyle = "MM-dd-yyyy HH:mm"
let startDate = dateFormatter.date(from: "08/09/2017 10:00")!
let endDate = dateFormatter.date(from: "08/09/2017 12:00")!

// HKUnit
let gramUnit = HKUnit.gram()
let meterUnit = HKUnit.meter()
let kiloMeterUnit = HKUnit.meterUnit(with: HKMetricPrefix.kilo)

let hourUnit = HKUnit.hour()
let decileter = HKUnit.literUnit(with: HKMetricPrefix.deci)
let deciletersPerHour = decileter.unitDivided(by: hourUnit)

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


let feetIn5K = fiveKilometers.doubleValue(
    for: HKUnit.foot()
)

let stonesIn2Grams = twoGrams.doubleValue(
    for: HKUnit.stone()
)



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
//let query = HKQuery.que

//HKSampleQuery
//HKObserverQuery
//HKStatisticsCollectionQuery/HKStatisticsQuery




    //HKAnchoredObjectQuery
    //HKCorrelationQuery

    //HKSourceQuery
    //HKStatisticsCollectionQuery


//