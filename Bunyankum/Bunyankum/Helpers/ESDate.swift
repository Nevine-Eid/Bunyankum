//
//  ESDateUtility.swift
//  3emala
//
//  Created by YoussefRomany on 2/20/20.
//  Copyright © 2019 youssefRomany. All rights reserved.
//

import Foundation


public class ESDate:NSObject {
    
    
    //MARK: - Current date methods
    
    /// get current string date in format "dd-MM-yyyy-hh:mm:ss"
    ///
    /// - Returns: the current date string
    public class func getCurrentStringDate()->String{
        return getDateFormatter().string(from: Date())
    }
    
    
    /// get current date as string in format "dd-MM-yyyy"
    ///
    /// - Returns: the current date
    public class func getCurrentDate()->String {
        return getCurrentStringDate(withFormat: "dd-MM-yyyy")
    }
    
    
    /// get current time as string in format "hh:mm:ss"
    ///
    /// - Returns: the current time
    public class func getCurrentTime()->String{
        return getCurrentStringDate(withFormat: "hh:mm:ss")
    }
    
    
    /// get current string date with a specific format
    ///
    /// - Parameter format: the date format
    /// - Returns: the string date for the specific format
    public class func getCurrentStringDate(withFormat format:String)->String{
        return getDateFormatter(withFormat: format).string(from: Date())
    }
    
    
    //MARK: - Other date methods
    
    /// split date and time from a string date
    ///
    /// - Parameters:
    ///   - str: the full date string
    ///   - format: the full date string format
    /// - Returns: the date and the time from the string date , if the full string date refer to today the date value will be "today"
    public class func getDateAndTimeStrings(fromDateString str:String,withFormat format:String)->(date:String,time:String)? {
        //check if date string and the format is valid
        if let date = getDate(fromatString: str, withFormat: format){
            
            let dateFormatter = getDateFormatter(withFormat: "d MMMM YYYY")
            var output:(date:String,time:String)
            //get date from the string
            //check if the is date is today
            if getCurrentStringDate(withFormat: "d MMMM YYYY") == dateFormatter.string(from: date) {
                output.date = "Today"
            }else{
                output.date = dateFormatter.string(from: date)
            }
            //get the time from the string
            dateFormatter.dateFormat = "h:mma"
            dateFormatter.amSymbol = "am"
            dateFormatter.pmSymbol = "pm"
            
            output.time = dateFormatter.string(from: date)
            return output
        }
        //the date string or the format was not valid
        return nil
    }
    
    
    
    /// get Date object from string date
    ///
    /// - Parameters:
    ///   - str: the full string date
    ///   - format: the full string date format
    /// - Returns: the Date object
    public class func getDate(fromatString str:String,withFormat format:String)->Date? {
        return getDateFormatter(withFormat: format).date(from: str)
    }
    
    /// get date as string from Seconds since 1970
    ///
    /// - Parameters:
    ///   - fromSeconds: the seconds from 1970
    ///   - format: the date string format
    /// - Returns: new date string
    public class func getDate(fromSeconds:Double, withFormat format:String)-> String {
        return getDateFormatter(withFormat: format).string(from: Date(timeIntervalSince1970: fromSeconds))
    }
    
    
    /// get DateFormatter object in english locale
    ///
    /// - Parameter format: the formatter you want , the default value is "dd-MM-yyyy-hh:mm:ss"
    /// - Returns: the DateFormatter object
    public class func getDateFormatter(withFormat format:String? = nil) -> DateFormatter {
        let format:String = format == nil ? "dd-MM-yyyy-hh:mm:ss" : format!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter
    }
    
    
    /// reformate date string
    ///
    /// - Parameters:
    ///   - date: the date string
    ///   - formate: current formate for given date string
    ///   - newFormat: new formate
    /// - Returns: date with new formate
    public class func reformat(dateString date:String, withFormat formate:String, newFromat newFormat:String)->String {
        let date =  getDate(fromatString: date, withFormat: formate) ?? Date()
        return getDateFormatter(withFormat: newFormat).string(from: date)
    }
    
    //MARK: - Human dates
    
    /// get human date for current time
    ///
    /// - Parameter localized: if you pass it true you will have the result localized based on ESKeys { ESYear : for years , ESMonth : for months , ESWeek : for weeks , ESDay : for days , ESHour : for hours , ESMinute : for minutes , ESSecond : for seconds } and you must put this keys in your Localizable.strings file for example "ESDay" = " days ago"; , default value localized is false
    /// - Returns: human date
    public class func getHumanDate(localized:Bool = false)->String {
        return getHumanDate(fromDate: Date(),localized: localized)
    }
    
    
    /// get human date from string date
    ///
    /// - Parameters:
    ///   - str: the full string date
    ///   - format: the full string date format
    ///   - localized: if you pass it true you will have the result localized based on ESKeys { ESYear : for years , ESMonth : for months , ESWeek : for weeks , ESDay : for days , ESHour : for hours , ESMinute : for minutes , ESSecond : for seconds } and you must put this keys in your Localizable.strings file for example "ESDay" = " days ago"; , default value localized is false
    /// - Returns: human date
    public class func getHumanDate(fromString str:String, withFormat format:String , localized:Bool = false) -> String? {
        let date = getDate(fromatString: str, withFormat: format)
        return date == nil ? nil : getHumanDate(fromDate: date!,localized: localized)
    }
    
    
    /// get human date from Date object
    ///
    /// - Parameters:
    ///   - date: the Date object
    ///   - localized: if you pass it true you will have the result localized based on ESKeys { ESYear : for years , ESMonth : for months , ESWeek : for weeks , ESDay : for days , ESHour : for hours , ESMinute : for minutes , ESSecond : for seconds } and you must put this keys in your Localizable.strings file for example "ESDay" = " days ago"; , default value localized is false
    /// - Returns: human date
    public class func getHumanDate(fromDate date:Date , localized:Bool = false)->String{
        let currentDate = Date()
        if currentDate.years(from: date)   > 0 {
            return localized ? "\(currentDate.years(from: date))" + localizedSitringFor(key: "ESYear") : "\(currentDate.years(from: date))y"
        }
        if currentDate.months(from: date)  > 0 {
            return localized ? "\(currentDate.months(from: date))" + localizedSitringFor(key: "ESMonth") : "\(currentDate.months(from: date))M"
        }
        if currentDate.weeks(from: date)   > 0 {
            return localized ? "\(currentDate.weeks(from: date))" + localizedSitringFor(key: "ESWeek") : "\(currentDate.weeks(from: date))w"
        }
        if currentDate.days(from: date)    > 0 {
            return localized ? "\(currentDate.days(from: date))" + localizedSitringFor(key: "ESDay") : "\(currentDate.days(from: date))d"
        }
        if currentDate.hours(from: date)   > 0 {
            return localized ? "\(currentDate.hours(from: date))" + localizedSitringFor(key: "ESHour") : "\(currentDate.hours(from: date))h"
        }
        if currentDate.minutes(from: date) > 0 {
            return localized ? "\(currentDate.minutes(from: date))" + localizedSitringFor(key: "ESMinute") : "\(currentDate.minutes(from: date))m"
        }
        if currentDate.seconds(from: date) > 0 {
            return localized ? "\(currentDate.seconds(from: date))" + localizedSitringFor(key: "ESSecond") : "\(currentDate.seconds(from: date))s"
        }
        return ""
    }
}

//MARK: - Date extension
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}

