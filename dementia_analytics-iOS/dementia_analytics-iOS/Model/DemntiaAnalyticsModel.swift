//
//  DemntiaAnalyticsModel.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/17.
//

import HealthKit

final class DementiaAnalyticsModel {
    static let shared = DementiaAnalyticsModel()
    
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
            print(error)
        }
    }
    
    func read(){
        // let start = makeStringToDate(str: "2023-05-01")
        // let end = Date()
        // let predicate = HKQuery.predicateForSamples(withStart:start, end: end, options: .strictStartDate)
        let awake = HKCategoryValueSleepAnalysis.predicateForSamples(.equalTo, value: .awake)
        let inBed = HKCategoryValueSleepAnalysis.predicateForSamples(.equalTo, value: .inBed)
        // let queryPredicate = HKSamplePredicate.sample(type: HKCategoryType(.sleepAnalysis), predicate: stagePredicate)
        let queryPredicate = HKSamplePredicate.sample(type: HKCategoryType(.sleepAnalysis))
        // let sleepQuery = HKSampleQueryDescriptor(predicates: [queryPredicate], sortDescriptors: [])
        // Task{
        //     let sleepSamples = try await sleepQuery.result(for: self.healthStore)
        //     print(sleepSamples[0])
        //     print(sleepSamples)
        // }
        
        let query = HKSampleQuery(sampleType: HKCategoryType(.sleepAnalysis),
                                  predicate: nil,
                                  limit: 30,
                                  sortDescriptors: []) { [weak self] (query, sleepResult, error) -> Void in
            if error != nil {
                return
            }
            if let result = sleepResult {
                DispatchQueue.main.async {
                    self?.sleepData = result as? [HKCategorySample] ?? []
                    print(result)
                }
            }
        }
        healthStore.execute(query)
    }
}
