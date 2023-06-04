//
//  DataType.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import Foundation

enum DADataType {
    case sleepBreathAverage
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
        }
    }
}