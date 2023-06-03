//
//  DemntiaAnalyticsModel.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/17.
//

import HealthKit
import Moya
import Combine
import CombineMoya

final class DementiaAnalyticsModel {
    static let shared = DementiaAnalyticsModel()
    var auth: Bool = false
    
    let healthStore = HKHealthStore()
    let readObejctType: Set<HKObjectType>
    var sleepData:[SleepType] = []
    
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
        let start = Date().addDate(byAddning: .year, value: -1)
        let end = Date().addDate(byAddning: .day, value: -1)
        let predicate = HKQuery.predicateForSamples(withStart:start, end: end, options: .strictStartDate)
        let query = HKSampleQuery(sampleType: HKCategoryType(.sleepAnalysis),
                                  predicate: predicate,
                                  limit: 100,
                                  sortDescriptors: []) { [weak self] (query, sleepResult, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let result = sleepResult {
                DispatchQueue.main.async {
                    self?.sleepData = (result as? [HKCategorySample] ?? []).compactMap{ sample in
                        SleepType(sample: sample)
                    }
                    print(self?.sleepData)
                }
            }
        }
        healthStore.execute(query)
    }
    
    func send(features: Features) -> AnyPublisher<Prediction?, Error> {
        let provider = MoyaProvider<APIService>()
        let featuresData = features.toJSON()!
        return provider.requestPublisher(.predict(featuresData))
            .map{ response -> Prediction? in
                return try? response.map(Prediction.self)
            }
            .mapError{ error in
                error as Error
            }
            .eraseToAnyPublisher()
    }
}
