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
        let nowDate = Date().toMidnight()
        let start = nowDate.addDate(byAddning: .year, value: -1)
        let end = nowDate.addDate(byAddning: .day, value: 1)
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
                                     options: HKStatisticsOptions,
                                     completion: @escaping (_ result: [HKStatistics]?, _ error: Error?) -> Void){
        let nowDate = Date().toMidnight()
        let start = nowDate.addDate(byAddning: .year, value: -1)
        let end = nowDate.addDate(byAddning: .day, value: 1)
        let predicate = HKQuery.predicateForSamples(withStart:start, end: end, options: .strictStartDate)
        let daily = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: predicate,
                                                options: options,
                                                anchorDate: start,
                                                intervalComponents: daily)
        
        query.initialResultsHandler = { _, statisticsCollection, error in
            if let statisticsCollection = statisticsCollection {
                completion(statisticsCollection.statistics(), nil)
            } else {
                completion(nil, error)
            }
        }
        self.healthStore.execute(query)
    }
    
    private func readHKCategorySamplePublisher(_ identifier: HKCategoryTypeIdentifier)
    -> AnyPublisher<[DAData]?, Never> {
        Future<[DAData]?, Never> { promise in
            self.readSampleQuery(sampleType: HKCategoryType(identifier)) { result, error in
                guard let result = result as? [HKCategorySample] else {
                    promise(.success(nil))
                    return }
                let sleepAnalysisData: [DAData] = result
                    .compactMap{ sample in
                        let data = DAData(sample: sample)
                        guard data.value > 0 else { return nil }
                        return data
                    }
                promise(.success(sleepAnalysisData))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func readStatisticsQueryPublisher(_ identifier: HKQuantityTypeIdentifier,
                                      options: HKStatisticsOptions) -> AnyPublisher<[DAData]?, Never>{
        Future<[DAData]?, Never> { promise in
            self.readStatisticsQuery(quantityType: HKQuantityType(identifier), options: options) { result, error in
                if let result = result {
                    let statisticsData = result.compactMap { data in
                        DAData(statistics: data)
                    }
                    promise(.success(statisticsData))
                } else {
                    promise(.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

extension DementiaAnalyticsModel {
    func readSleepAnalysisData() -> AnyPublisher<[DAData]?, Never> {
        return readHKCategorySamplePublisher(.sleepAnalysis)
    }
    
    func readSleepChangeData() -> AnyPublisher<[DAData]?, Never> {
        return readHKCategorySamplePublisher(.sleepChanges)
    }
    
    func readActivitEnergyBurned() -> AnyPublisher<[DAData]?, Never> {
        return readStatisticsQueryPublisher(.activeEnergyBurned, options: .cumulativeSum)
    }
    
    func readBasalEnergyBurned() -> AnyPublisher<[DAData]?, Never> {
        return readStatisticsQueryPublisher(.basalEnergyBurned, options: .cumulativeSum)
    }
    
    func readDistanceWalkingRunning() -> AnyPublisher<[DAData]?, Never> {
        return readStatisticsQueryPublisher(.distanceWalkingRunning, options: .cumulativeSum)
    }
    
    func readStepCount() -> AnyPublisher<[DAData]?, Never> {
        return readStatisticsQueryPublisher(.stepCount, options: .cumulativeSum)
    }
}
