//
//  DemntiaAnalyticsModel.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/17.
//

import HealthKit

final class DementiaAnalyticsModel {
    static let shared = DementiaAnalyticsModel()
    var auth: Bool = false
    
    let healthStore = HKHealthStore()
    let readObejctType: Set<HKObjectType>
    var sleepData:[HKCategorySample] = []
    
    private init() {
        let readQuantityTypeIdentifiers: [HKQuantityTypeIdentifier] = [
            .activeEnergyBurned,
            .basalEnergyBurned,
            .distanceWalkingRunning,
            .stepCount
        ]
        let readQuantityType: [HKSampleType] = readQuantityTypeIdentifiers
            .compactMap { HKQuantityType($0) }
        let readCategoryTypeIdentifier: [HKCategoryTypeIdentifier] = [
            .sleepAnalysis,
            .sleepChanges
        ]
        let readCategoryType: [HKSampleType] = readCategoryTypeIdentifier
            .compactMap{ HKCategoryType($0) }
        
        let readIdentifiers:[HKSampleType] = readQuantityType + readCategoryType
        
        let readObejctType = Set(readIdentifiers)
        self.readObejctType = readObejctType
    }
    
    func request() {
        healthStore.requestAuthorization(toShare: nil, read: self.readObejctType) { result, error in
            self.auth = result
        }
    }
    
    func read(){
        let start = "2023-05-30".toDate()
        let end = start
        let predicate = HKQuery.predicateForSamples(withStart:start, end: end, options: .strictStartDate)
        let queryPredicate = HKCategoryValueSleepAnalysis.predicateForSamples(.equalTo, value:.asleepREM)
        
        let query = HKSampleQuery(sampleType: HKCategoryType(.sleepAnalysis),
                                  predicate: predicate,
                                  limit: 30,
                                  sortDescriptors: []) { [weak self] (query, sleepResult, error) -> Void in
            if error != nil {
                return
            }
            if let result = sleepResult {
                DispatchQueue.main.async {
                    self?.sleepData = (result as? [HKCategorySample] ?? [])
                    (result as? [HKCategorySample] ?? []).compactMap{ sample in
                        SleepType(sample: sample)
                    }
                }
            }
        }
        healthStore.execute(query)
    }
}
