//
//  SleepValue.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import HealthKit

enum SleepType: Int {
    case inBed
    case asleep
    case awake
    case asleepCore
    case asleepDeep
    case asleepRem
}

struct SleepValue: CustomStringConvertible{
    let type: SleepType?
    let startDate: Date
    let endDate: Date
    
    var durationMinute: Int? {
        return endDate.diff(previous: startDate).minute
    }
    
    var description: String {
        return "SleepValue{\n\(type!)\nstartDate: \(startDate.koString())\nendDate: \(endDate.koString())\nduration: \(durationMinute)}"
    }
    
    init(typeValue: Int?, startDate: Date, endDate: Date) {
        if let typeValue = typeValue {
            self.type = SleepType(rawValue: typeValue)
        } else {
            self.type = nil
        }
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(sample: HKCategorySample){
        let value = sample.value(forKey:HKPredicateKeyPathCategoryValue) as? Int
        if let value = value {
            self.type = SleepType(rawValue: value)
        } else {
            self.type = nil
        }
        self.startDate = sample.startDate
        self.endDate = sample.endDate
    }
}
