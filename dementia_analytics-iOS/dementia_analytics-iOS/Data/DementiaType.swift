//
//  DementiaType.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import UIKit

enum DementiaType: Int {
    case cn
    case dem
    case mci
}

extension DementiaType {
    var label: String {
        switch self {
        case .cn: return "정상인"
        case .dem: return "치매 환자"
        case .mci: return "경증 치매 환자"
        }
    }
    
    var color: UIColor {
        switch self {
        case .cn: return .daGreen
        case .dem: return .daRed
        case .mci: return .daOrange
        }
    }
}
