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
}
