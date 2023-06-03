//
//  Prediction.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/03.
//

import Foundation

enum PredictionLabel: Int {
    case DEM = 1
    case MCI = 2
    case CN = 0
}

struct Prediction: Codable {
    let prediction: [Int]
    
    var label: PredictionLabel? {
        guard let pred = prediction.first else { return nil }
        return PredictionLabel(rawValue: pred)
    }
}
