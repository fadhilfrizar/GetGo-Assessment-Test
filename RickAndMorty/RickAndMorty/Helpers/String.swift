//
//  String.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 21/02/23.
//

import Foundation

extension String {
    func convertStringToDateString() -> String{
        var dateString = ""
        
        //get user's timezone. If nil, default to UTC/GMT
        var userTimezone: String { return TimeZone.current.abbreviation() ?? "UTC" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(identifier: userTimezone)
        var date = dateFormatter.date(from: self)
        
        if date == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(identifier: userTimezone)
            date = dateFormatter.date(from: self)
        }
        
        let newDateFormatter  = DateFormatter()
        newDateFormatter.dateFormat = "hh:mm, dd MMMM YYYY"
        
        dateString = newDateFormatter.string(from: date ?? Date())
        
        return dateString
    }
    
}

