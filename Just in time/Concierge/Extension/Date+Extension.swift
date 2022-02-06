//
//  Date+Extension.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import Foundation

extension Date {
    func secondsSince(date: Date) -> Float {
        let diff = Float(self.timeIntervalSince1970 - date.timeIntervalSince1970)
        return diff
    }
}
