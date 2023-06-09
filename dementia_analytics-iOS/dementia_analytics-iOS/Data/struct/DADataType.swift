//
//  DataType.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import Foundation

enum SleepType: Int {
    case inBed = 0
    case asleep
    case awake
    case asleepCore
    case asleepDeep
    case asleepRem
}

extension SleepType {
    var daDataType: DADataType {
        switch self {
        case .inBed: return .sleepDuration
        case .asleep: return .sleepDuration
        case .awake: return .sleepAwake
        case .asleepCore: return .unknown
        case .asleepDeep: return .sleepDeep
        case .asleepRem: return .sleepRem
        }
    }
}

enum DADataType: Int {
    case sleepBreathAverage = 0
    case sleepHrAverage
    case sleepHrLowest
    case sleepDeep
    case sleepRem
    case activityCalTotal
    case sleepAwake
    case activitySteps
    case activityTotal
    case sleepDuration
    case activityDailyMovement
    case unknown
    case activityCal
    case basalCal
}

extension DADataType {
    var title: String {
        switch self {
        case .sleepBreathAverage: return StringCollection.sleepBreathAverage
        case .sleepHrAverage: return StringCollection.sleepHrAverage
        case .sleepHrLowest: return StringCollection.sleepHrLowest
        case .sleepDeep: return StringCollection.sleepDeep
        case .sleepRem: return StringCollection.sleepRem
        case .activityCalTotal: return StringCollection.activityCalTotal
        case .sleepAwake: return StringCollection.sleepAwake
        case .activitySteps: return StringCollection.activitySteps
        case .activityTotal: return StringCollection.activityTotal
        case .sleepDuration: return StringCollection.sleepDuration
        case .activityDailyMovement: return StringCollection.activityDailyMovement
        default: return ""
        }
    }
    
    var of: String {
        switch self {
        case .activityCalTotal,
                .activityDailyMovement,
                .activitySteps,
                .sleepHrLowest:
            return "와"
        case .activityTotal,
                .sleepDeep,
                .sleepRem,
                .sleepAwake,
                .sleepDuration,
                .sleepHrAverage,
                .sleepBreathAverage:
            return "과"
        default: return ""
        }
    }
}
