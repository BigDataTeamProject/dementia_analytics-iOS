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
    let readQuantityType: [HKQuantityType]
    let readCategoryType: [HKCategoryType]
    
    var sleepData:[SleepValue] = []
    
    private init() {
        let readQuantityTypeIdentifiers: [HKQuantityTypeIdentifier] = [
            .activeEnergyBurned,
            .basalEnergyBurned,
            .distanceWalkingRunning,
            .stepCount
        ]
        let readCategoryTypeIdentifier: [HKCategoryTypeIdentifier] = [
            .sleepAnalysis,
            .sleepChanges
        ]
        
        self.readQuantityType = readQuantityTypeIdentifiers
            .compactMap { HKQuantityType($0) }
        self.readCategoryType = readCategoryTypeIdentifier
            .compactMap{ HKCategoryType($0) }
        
        let readIdentifiers: [HKSampleType] = readQuantityType + readCategoryType
        let readObejctType = Set(readIdentifiers)
        self.readObejctType = readObejctType
    }
    
    func request() {
        healthStore.requestAuthorization(toShare: nil, read: self.readObejctType) { result, error in
            self.auth = result
        }
    }
    
    private func readSampleQuery(sampleType: HKSampleType,
                            completion: @escaping (_ result: [HKSample]?, _ error: Error?) -> Void){
        let start = Date().addDate(byAddning: .year, value: -3)
        let end = Date().addDate(byAddning: .day, value: 1)
        let predicate = HKQuery.predicateForSamples(withStart:start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: predicate,
                                  limit: Int(HKObjectQueryNoLimit),
                                  sortDescriptors: [sortDescriptor]) { (query, sleepResult, error) -> Void in
            DispatchQueue.main.async {
                completion(sleepResult, error)
            }
        }
        healthStore.execute(query)
    }
    
    private func readStatisticsQuery(quantityType: HKQuantityType,
                            completion: @escaping (_ result: [HKSample]?, _ error: Error?) -> Void){
        let start = Date().addDate(byAddning: .year, value: -3)
        let end = Date().addDate(byAddning: .day, value: 1)
        let predicate = HKQuery.predicateForSamples(withStart:start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
    
        let query = HKStatisticsQuery(quantityType: quantityType,
                                      quantitySamplePredicate: predicate,
                                      options: <#T##HKStatisticsOptions#>, completionHandler: <#T##(HKStatisticsQuery, HKStatistics?, Error?) -> Void#>)
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

extension DementiaAnalyticsModel {
    func readSleepAnalysisData(){
        self.readSampleQuery(sampleType: HKCategoryType(.sleepAnalysis)) { [weak self] result, error in
            guard let result = result else { return }
            self?.sleepData = (result as? [HKCategorySample] ?? []).compactMap{ sample in
                let value = SleepValue(sample: sample)
                guard let minute = value.durationMinute, minute > 0,
                      value.type != nil else { return nil }
                return value
            }
        }
    }
    
    func readSleepChangeData(){
        self.readSampleQuery(sampleType: HKCategoryType(.sleepChanges)) { [weak self] result, error in
            guard let result = result else { return }
            self?.sleepData = (result as? [HKCategorySample] ?? []).compactMap{ sample in
                let value = SleepValue(sample: sample)
                guard let minute = value.durationMinute, minute > 0,
                      value.type != nil else { return nil }
                return value
            }
        }
    }
    
    func readActivitEnergyBurned(){
        self.readSampleQuery(sampleType: HKQuantityType(.activeEnergyBurned)) { [weak self] result, error in
    
            guard let result = result, let sum = result.sumQuantity() else { return }
            let cal = sum.doubleValue(for: HKUnit.kilocalorie())
        }
    }
}
