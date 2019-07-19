//
//  Date+String.swift
//  Debatable
//
//  Created by Jony Tucci on 4/3/19.
//  Copyright © 2019 RedditiOS. All rights reserved.
//

import Foundation

public extension Date {
    
    // MARK: - Properties
    // Cached static array of dateformatters used to improve performance
    private static var cachedDateFormatters = [String: DateFormatter]()
    
    // MARK: - Initialization
    /// Initializes a new Date object based on a string passed in as an argument
    ///
    /// - Parameters:
    ///   - string: Date in string format
    ///   - format: DateFormat specifying desired format.
    ///   - timeZone: timezone of date. Defaults to local
    ///   - locale: locale of date. Defaults to users current locale
    //
    /// - Returns: a Date() object if succesfully converted else returns nil
    init?(
        fromString string: String,
        format: DateFormat,
        timeZone: TimeZoneType = .local,
        locale: Locale = Foundation.Locale.current) {
        
        guard !string.isEmpty else { return nil }
        let dateString = string
        let formatter = Date.cachedFormatter(format.stringFormat, timeZone: timeZone.timeZone, locale: locale)
        guard let date = formatter.date(from: dateString) else { return nil }
        self.init(timeInterval: 0, since: date)
    }
    
    // MARK: - Convert to String
    func toString(format: DateFormat, timeZone: TimeZoneType = .local, locale: Locale = Locale.current) -> String {
        let formatter = Date.cachedFormatter(format.stringFormat, timeZone: timeZone.timeZone, locale: locale)
        return formatter.string(from: self)
    }
    
    // MARK: Cached Formatters
    private static func cachedFormatter(
        _ format: String = DateFormat.standard.stringFormat,
        timeZone: Foundation.TimeZone = Foundation.TimeZone.current,
        locale: Locale = Locale.current
        ) -> DateFormatter {
        
        let hashKey = "\(format.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
        if Date.cachedDateFormatters[hashKey] == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatter.isLenient = true
            Date.cachedDateFormatters[hashKey] = formatter
        }
        return Date.cachedDateFormatters[hashKey]!
    }
    
    private static func cachedFormatter(
        _ dateStyle: DateFormatter.Style,
        timeStyle: DateFormatter.Style,
        doesRelativeDateFormatting: Bool,
        timeZone: Foundation.TimeZone = Foundation.NSTimeZone.local,
        locale: Locale = Locale.current
        ) -> DateFormatter {
        
        let hashKey = """
        \(dateStyle.hashValue)\
        \(timeStyle.hashValue)\
        \(doesRelativeDateFormatting.hashValue)\
        \(timeZone.hashValue)\
        \(locale.hashValue)
        """
        
        if Date.cachedDateFormatters[hashKey] == nil {
            let formatter = DateFormatter()
            formatter.dateStyle = dateStyle
            formatter.timeStyle = timeStyle
            formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatter.isLenient = true
            Date.cachedDateFormatters[hashKey] = formatter
        }
        return Date.cachedDateFormatters[hashKey]!
    }
} // END extension Date

// MARK: - Enums

///  The string format used for date string conversion.
public enum DateFormat {
    
    /// ISO8601 "EEE MMM dd HH:mm:ss Z yyyy" ex. Wed Apr 03 10:15:23 -0700 2019
    case standard
    
    /// "EEEE, MMM d, yyyy" ex. Wednesday, Apr 3, 2019
    case dayDateLong
    
    /// "MMM d, h:mm a" ex. Apr 3, 5:18 PM
    case dateTime12
    
    /// "MMMM yyyy" ex. April 2019
    case monthYear
    
    /// ISO8601 "yyyy-MM-dd" i.e. 2019-04-03
    case isoDate
    
    /// ISO8601 "yyyy-MM-dd'T'HH:mmZ" ex. 2019-04-03T10:12-0700
    case isoDateTime
    
    /// ISO8601 "yyyy-MM-dd'T'HH:mm:ssZ" ex. 2019-04-03T10:13:20-0700
    case isoDateTimeSec
    
    /// ISO8601 "yyyy-MM-dd'T'HH:mm:ss.SSSZ" ex. 2019-04-03T10:13:59.018-0700
    case isoDateTimeMilliSec
    
    /// ISO8601 "yyyy" ex. 2019
    case isoYear
    
    /// ISO8601 "yyyy-MM" ex. 2019-04
    case isoYearMonth
    
    /// A custom date format string
    case custom(String)
    
    var stringFormat: String {
        switch self {
        case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
        case .dayDateLong: return "EEEE, MMM d, yyyy"
        case .dateTime12: return "MMM d, h:mm a"
        case .monthYear: return ""
        case .isoDate: return "yyyy-MM-dd"
        case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
        case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .isoYear: return "yyyy"
        case .isoYearMonth: return "yyyy-MM"
        case .custom(let customFormat): return customFormat
        }
    }
} // END Date Format

public enum TimeZoneType {
    case local, `default`, utc, custom(Int)
    var timeZone: TimeZone {
        switch self {
        case .local: return NSTimeZone.local
        case .default: return NSTimeZone.default
        case .utc: return TimeZone(secondsFromGMT: 0)!
        case let .custom(gmt): return TimeZone(secondsFromGMT: gmt)!
        }
    }
}
