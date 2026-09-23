//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Mohamed Elbendary on 23/09/2026.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}
