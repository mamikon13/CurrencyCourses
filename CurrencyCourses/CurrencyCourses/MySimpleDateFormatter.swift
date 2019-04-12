//
//  DateFormatter.swift
//  CurrencyCourses
//
//  Created by Mamikon Nikogosyan on 17/01/2019.
//  Copyright © 2019 Mamikon Nikogosyan. All rights reserved.
//

import Foundation


class MySimpleDateFormatter: DateFormatter {
    
    let dateFormatter = DateFormatter()
    
    func fromStringToDate(date stringDate: String, dateFormat: String = "dd.MM.yyyy") -> Date? {
        self.dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: stringDate)
    }
    
    func fromDateToString(date: Date?, dateFormat: String = "dd.MM.yyyy") -> String {
       
        if date == nil {
            return "12.12.2013"
        }
        
        self.dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date!)
    }
}
