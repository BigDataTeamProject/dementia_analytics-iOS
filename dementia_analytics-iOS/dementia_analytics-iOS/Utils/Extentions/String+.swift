//
//  String+.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import Foundation

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        return dateFormatter.date(from: self)!
    }
}
