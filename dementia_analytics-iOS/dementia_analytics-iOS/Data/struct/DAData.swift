//
//  DAData.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/05.
//

import Foundation
import CoreData
import CoreDataStorage
import HealthKit

struct DAData {
    let type: DADataType
    let startDate: Date
    let endDate: Date
    let value: CGFloat
    
    var durationMinute: Int? {
        return endDate.diff(previous: startDate).minute
    }
    
    init(statistics: HKStatistics){
        let identifier = statistics.quantityType.identifier
        switch identifier {
        case HKQuantityTypeIdentifier.activeEnergyBurned.rawValue:
            self.type = .activityCal
            self.value = statistics.sumQuantity()?.doubleValue(for: HKUnit.largeCalorie()) ?? 0.0
        case HKQuantityTypeIdentifier.basalEnergyBurned.rawValue:
            self.type =  .basalCal
            self.value = statistics.sumQuantity()?.doubleValue(for: HKUnit.largeCalorie()) ?? 0.0
        case HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue:
            self.type = .activityDailyMovement
            self.value = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0.0
        case HKQuantityTypeIdentifier.stepCount.rawValue:
            self.type = .activitySteps
            self.value = statistics.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
        default:
            self.type = .unknown
            self.value = 0.0
        }
        self.startDate = statistics.startDate
        self.endDate = statistics.endDate
    }
    
    init(sample: HKCategorySample){
        let value = sample.value(forKey:HKPredicateKeyPathCategoryValue) as? Int
        if let value = value {
            self.type = SleepType(rawValue: value)?.daDataType ?? .unknown
        } else {
            self.type = .unknown
        }
        if self.type == .sleepRem {
            self.startDate = sample.startDate.toMidnight()
        } else {
            self.startDate = sample.startDate.addDate(byAddning: .day, value: 1).toMidnight()
        }
        
        self.endDate = sample.endDate
        self.value = CGFloat(sample.endDate.diff(previous: sample.startDate).minute!)
    }
    
    init(type: DADataType, startDate: Date, endDate: Date, value: CGFloat){
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.value = value
    }
    
    func sum(value: CGFloat) -> Self {
        DAData(type: type,
               startDate: startDate,
               endDate: endDate,
               value: self.value + value)
    }
}

extension DAData: Entitable {
    func toEntity(in context: NSManagedObjectContext) -> DADataEntity {
        let entity: DADataEntity = .init(context: context)
        entity.type = Int16(type.rawValue)
        entity.startDate = startDate
        entity.endDate = endDate
        entity.value = Float(value)
        return entity
    }
}

extension DADataEntity: Objectable {
    public func toObject() -> some Entitable {
        return DAData(type: DADataType(rawValue: Int(type)) ?? .unknown,
                      startDate: startDate ?? Date(),
                      endDate: endDate ?? Date(),
                      value: CGFloat(value))
    }
}
