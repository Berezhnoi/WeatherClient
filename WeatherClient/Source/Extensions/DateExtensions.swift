//
//  DateExtensions.swift
//  WeatherClient
//
//  Created by rendi on 25.05.2024.
//

import Foundation

extension Date {
    func startOfDay() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: self)
    }
    
    func formatted(as format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dayOfWeek() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "Today"
        } else {
            return self.formatted(as: "E")
        }
    }
}
