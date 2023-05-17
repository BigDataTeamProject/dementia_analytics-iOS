//
//  DemntiaAnalyticsModel.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/17.
//

import HealthKit

final class DementiaAnalyticsModel {
    static let shared = DementiaAnalyticsModel()
    
    let store = HKHealthStore()
    let readObejctType: Set<HKObjectType>
    
    private init() {
        // let readQuantityTypeIdentifiers: [HKQuantityTypeIdentifier] = [
        //
        // ].compactMap { HKQuantityType($0) }
        // let readCategoryTypeIdentifier: [HKCategoryTypeIdentifier] = [
        //     .sleepAnalysis,
        //     .sleepChanges
        // ]
        //
        // let readIdentifiers:[HKSampleType] = readQuantityTypeIdentifiers as [HKSampleType] + readCategoryTypeIdentifier as [HKSampleType]
        //
        // self.readObejctType = Set(readIdentifiers)
        //
        //
        // let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.quantityType(forIdentifier: .stepCount)!, HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
        //                 HKObjectType.activitySummaryType()])
    }
    
    func request() {
        store.requestAuthorization(toShare: nil, read: self.readObejctType) { result, error in
            print(result, error)
        }
    }
}
