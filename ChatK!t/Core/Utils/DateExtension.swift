//
//  DateExtension.swift
//  ChatK!t
//
//  Created by ben3 on 24/04/2021.
//

import Foundation
import DateTools

public extension Date {
    
    func dateAgo() -> String {
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            return Strings.t(Strings.today)
        }
        if calendar.isDateInYesterday(self) {
            return Strings.t(Strings.yesterday)
        }
        let formatter = DateFormatter()
        if self.nsDate().daysAgo() < 7 {
            formatter.dateFormat = "EEE"
        } else {
            formatter.dateFormat = "dd/MM/yy"
        }
        return formatter.string(from: self)
    }
    
    func nsDate() -> NSDate {
        return NSDate(timeIntervalSinceReferenceDate: timeIntervalSinceReferenceDate)
    }
    
    func timeAgo(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = ChatKit.config().timeFormat
        
        let time = formatter.string(from: self)
        let day = dateAgo()
        
        return String(format: Strings.t(Strings.lastSeen_at_), day, time)
    }
    
    func dayComponents() -> DateComponents {
        get(.day, .month, .year)
    }

    func day() -> Date? {
        Calendar.current.date(from: dayComponents())
    }

    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        calendar.component(component, from: self)
    }
        
    func lastSeenTimeAgo() -> String {
        return timeAgo(format: Strings.lastSeen_at_)
    }

}
