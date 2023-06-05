//
//  Date+.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import Foundation

extension Date {
    func toMidnight() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func koString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm" // 24 시간 대 설정
        formatter.locale = Locale(identifier: "ko_kr") // 한국 시간 지정
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter.string(from: self)
    }
    
    func koShortString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd" // 24 시간 대 설정
        formatter.locale = Locale(identifier: "ko_kr") // 한국 시간 지정
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter.string(from: self)
    }
    
    func diff(previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: self).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: self).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: self).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: self).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: self).second
        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    func addDate(byAddning: Calendar.Component, value: Int)-> Date {
        return Calendar.current.date(byAdding: byAddning, value: value, to: self) ?? self
    }
}
