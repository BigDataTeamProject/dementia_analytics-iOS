//
//  SleepType.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import HealthKit

struct SleepType{
    let type: HKCategoryValueSleepAnalysis?
    let startDate: Date
    let endDate: Date
    
    init(typeValue: Int?, startDate: Date, endDate: Date) {
        if let typeValue = typeValue {
            self.type = HKCategoryValueSleepAnalysis(rawValue: typeValue)
        } else {
            self.type = nil
        }
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(sample: HKCategorySample){
        // if let typeValue = typeValue {
        //     self.type = HKCategoryValueSleepAnalysis(rawValue: typeValue)
        // } else {
        //     self.type = nil
        // }
        let value = sample.value(forKey:HKPredicateKeyPathCategoryValue)
        print(value)
        self.type = nil
        self.startDate = sample.startDate
        self.endDate = sample.endDate
    }
}
