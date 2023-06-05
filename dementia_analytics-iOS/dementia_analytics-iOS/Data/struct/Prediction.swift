//
//  Prediction.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/03.
//

import Foundation

struct Prediction: Codable {
    let prediction: [Int]
    
    var dementiaType: DementiaType? {
        guard let pred = prediction.first else { return nil }
        return DementiaType(rawValue: pred)
    }
}
