//
//  Date+.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import Foundation

extension Date {
    func addDate(byAddning: Calendar.Component, value: Int)-> Date {
        return Calendar.current.date(byAdding: byAddning, value: value, to: self) ?? self
    }
}
