//
//  GreenExtension+Date.swift
//  GProject
//
//  Created by KieuVan on 3/23/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit

let  dateTimeInstance = DateTimeInstance.sharedInstance()

class DateTimeInstance: NSObject {
    static var instance: DateTimeInstance!
    var calendar = Locale.current.calendar
    class func sharedInstance() -> DateTimeInstance {
        if(self.instance == nil) {
            self.instance = (self.instance ?? DateTimeInstance())
        }
        return self.instance
    }
    
    func getComponent(date : Date)->DateComponents {
//        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    }
}


public extension Date {
    
    func indexOfdateInWeek() -> Int? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return weekDay
    }
    
    func toZeroGMT() -> Date {
        return self.addingTimeInterval(-25200)
    }
    
    func year() -> Int {
        return dateTimeInstance.getComponent(date: self).year!;
    }
    
    func month() -> Int {
        return dateTimeInstance.getComponent(date: self).month!;
    }
    
    func day() -> Int {
        return dateTimeInstance.getComponent(date: self).day!;
    }
    
    func hour() -> Int {
        return dateTimeInstance.getComponent(date: self).hour!;
    }
    
    func minute() -> Int {
        return dateTimeInstance.getComponent(date: self).minute!;
    }
    
    func add(day : Int)-> Date {
        var component = DateComponents.init()
        component.day = day
        return dateTimeInstance.calendar .date(byAdding: component, to: self)!
    }
    
    func isAfter(date : Date) -> Bool {
        if self.compare(date) == ComparisonResult.orderedAscending {
            return false
        } else {
            return true
        }
    }
    
    func isBefore(date : Date) ->Bool {
        return !isAfter(date: date)
    }
    
    func isTheSameDay(target : Date)->Bool {
        let d = target.toZeroGMT()
        if(self.toZeroGMT().year() == d.year() && self.toZeroGMT().month() == d.month() && self.toZeroGMT().day() == d.day()) {
            return true;
        }
        return false;
    }
    
    
    
    func dateInWeek() -> [Date] {
        var output : [Date]  = []
        for i in   2...8 {
            let unitDate : Date = self.add(day: i - ( self.indexOfdateInWeek()!))
            output.append(unitDate)
        }
        return output
    }
    func getIndexWeekOfYear() -> Int {
        var index = 0
        index = Calendar.current.component(.weekOfYear, from: self)
        return index
    }
    func addingMonth(months: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.month = months
        
        return calendar.date(byAdding: components, to: self)
    }
    
    
    static func dateFrom(day: Int, month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let date = userCalendar.date(from: dateComponents)
        return date
    }
    
    func isBigger(to: Date) -> Bool {
        return Calendar.current.compare(self, to: to, toGranularity: .day) == .orderedDescending ? true : false
    }
    
    func isSmaller(to: Date) -> Bool {
        return Calendar.current.compare(self, to: to, toGranularity: .day) == .orderedAscending ? true : false
    }
    
    func isEqual(to: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: to)
    }
    
    func isBetweenTwoDate(from: Date, to: Date) -> Bool{
        if self.isEqual(to: from) || self.isEqual(to: to) {
            return true
        }
        if self.isBigger(to: from) && self.isSmaller(to: to) {
            return true
        }
        return false
    }
    
    static func now() -> Date {
        return Date()
    }
    
    func isNullDate() -> Bool {
        if self.year() == 1 {
            return true
        }
        return false
    }
    
    static func daysBetween(from: Date, to: Date) -> Int {
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: from)
        let date2 = calendar.startOfDay(for: to)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day!
        
    }
    func changeTime(hour: Int , min: Int) -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        
        // Change the time to 9:30:00 in your locale
        components.hour = hour
        components.minute = min
        return gregorian.date(from: components)!

    }
}
extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    /**
     Get start Date in current Date ; Ex: 0:0AM
     */
    func startDateForCurrentDate() -> Date? {
        let calendar = Calendar.current
        let dateAtMidnight = calendar.startOfDay(for: self)
        return dateAtMidnight
    }
    /**
     Get end Date in current Date ; Ex: 0:0AM
     */
    func endDateForCurrentDate() -> Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let calendar = Calendar.current
        let dateAtEnd = calendar.date(byAdding: components, to: self.startDateForCurrentDate()!)
        return dateAtEnd
    }
}
