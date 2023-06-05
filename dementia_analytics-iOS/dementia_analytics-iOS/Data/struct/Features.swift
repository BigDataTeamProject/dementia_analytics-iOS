//
//  Features.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/03.
//

import Foundation

struct Features: Codable {
    let sleepBreathAverage: CGFloat
    let sleepHrAverage: CGFloat
    let sleepHrLowest: CGFloat
    let sleepDeep: CGFloat
    let sleepRem: CGFloat
    let activityCalTotal: CGFloat
    let sleepAwake: CGFloat
    let activitySteps: CGFloat
    let activityTotal: CGFloat
    let sleepDuration: CGFloat
    let activityDailyMovement: CGFloat
    
    func getValue(dataType: DADataType) -> CGFloat {
        switch dataType {
        case .sleepBreathAverage: return sleepBreathAverage
        case .sleepHrAverage: return sleepHrAverage
        case .sleepHrLowest: return sleepHrLowest
        case .sleepDeep: return sleepDeep
        case .sleepRem: return sleepRem
        case .activityCalTotal: return activityCalTotal
        case .sleepAwake: return sleepAwake
        case .activitySteps: return activitySteps
        case .activityTotal: return activityTotal
        case .sleepDuration: return sleepDuration
        case .activityDailyMovement: return activityDailyMovement
        default:
            return 0.0
        }
    }
}

extension Features {
    enum CodingKeys : String, CodingKey {
        case sleepBreathAverage = "sleep_breath_average"
        case sleepHrAverage = "sleep_hr_average"
        case sleepHrLowest = "sleep_hr_lowest"
        case sleepDeep = "sleep_deep"
        case sleepRem = "sleep_rem"
        case activityCalTotal = "activity_cal_total"
        case sleepAwake = "sleep_awake"
        case activitySteps = "activity_steps"
        case activityTotal = "activity_total"
        case sleepDuration = "sleep_duration"
        case activityDailyMovement = "activity_daily_movement"
    }
    
    func toJSON() -> Data?{
        return try? JSONEncoder().encode(self)
    }
    
    func toDAData(_ date: Date) -> [DAData]{
        let startDate = date
        let endDate = date.addDate(byAddning: .day, value: 1)
        return [
            DAData(type: .sleepBreathAverage, startDate: startDate, endDate: endDate, value: sleepBreathAverage),
            DAData(type: .sleepHrAverage, startDate: startDate, endDate: endDate, value: sleepHrAverage),
            DAData(type: .sleepHrLowest, startDate: startDate, endDate: endDate, value: sleepHrLowest),
            DAData(type: .sleepDeep, startDate: startDate, endDate: endDate, value: sleepDeep),
            DAData(type: .sleepRem, startDate: startDate, endDate: endDate, value: sleepRem),
            DAData(type: .activityCalTotal, startDate: startDate, endDate: endDate, value: activityCalTotal),
            DAData(type: .sleepAwake, startDate: startDate, endDate: endDate, value: sleepAwake),
            DAData(type: .activitySteps, startDate: startDate, endDate: endDate, value: activitySteps),
            DAData(type: .activityTotal, startDate: startDate, endDate: endDate, value: activityTotal),
            DAData(type: .sleepDuration, startDate: startDate, endDate: endDate, value: sleepDuration),
            DAData(type: .activityDailyMovement, startDate: startDate, endDate: endDate, value: activityDailyMovement)
           ]
    }
}

extension Features {
    static let testDataMCI: Self = Features(sleepBreathAverage: 16.875,
                                            sleepHrAverage: 57.95,
                                            sleepHrLowest: 51.0,
                                            sleepDeep: 5610.0,
                                            sleepRem: 4230.0,
                                            activityCalTotal: 2164.0,
                                            sleepAwake: 8190.0,
                                            activitySteps: 2849.0,
                                            activityTotal: 143.0,
                                            sleepDuration: 37440.0,
                                            activityDailyMovement: 2098.0)
    
    static let testDataCN: Self = Features(sleepBreathAverage: 16.1,
                                           sleepHrAverage: 60.0,
                                           sleepHrLowest: 54.0,
                                           sleepDeep: 7170.0,
                                           sleepRem: 4440.0,
                                           activityCalTotal: 1715.0,
                                           sleepAwake: 2280.0,
                                           activitySteps: 8015.0,
                                           activityTotal: 349.0,
                                           sleepDuration: 28740.0,
                                           activityDailyMovement: 6231.0)
    
    static let testDataDem: Self = Features(sleepBreathAverage: 17.1,
                                            sleepHrAverage: 57.4,
                                            sleepHrLowest: 51.0,
                                            sleepDeep: 3634.9,
                                            sleepRem: 4541.4,
                                            activityCalTotal: 2754.0,
                                            sleepAwake: 5695.0,
                                            activitySteps: 14637.0,
                                            activityTotal: 422.0,
                                            sleepDuration: 27337.0,
                                            activityDailyMovement: 12695.0)
}
