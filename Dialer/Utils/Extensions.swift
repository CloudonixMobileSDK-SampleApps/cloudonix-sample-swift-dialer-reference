//
//  Extensions.swift
//  Cloudonix Example Dialer
//
//  Authors:
//   - Igor Nazarov, 2017-08-16
//   - Oded Arbel, 2022-06-21
//
//  Copyright © 2017 Cloudonix, Inc.
//  Modification, in whole or in part, including copying portions of the work - for use
//  in other software that uses the Cloudonix Mobile SDK - is permitted, without limitation.
//  All other rights reserved.
//

import Foundation
import UIKit

extension Double {
    
    func toTimeString() -> String {
        let selfInt = Int(self)
        
        let hours = selfInt / 3600
        let minutes = (selfInt - hours * 3600) / 60
        let seconds = selfInt - hours * 3600 - minutes * 60
        
        var hoursStr = ""
        if hours > 0 && hours < 10 {
            hoursStr = "0" + String(hours)
        } else if hours >= 10 {
            hoursStr = String(hours)
        }
        if hours > 0 {
            hoursStr.append(":")
        }
        
        var minutesStr = "00"
        if minutes > 0 && minutes < 10 {
            minutesStr = "0" + String(minutes)
        } else if minutes >= 10 {
            minutesStr = String(minutes)
        }
        
        var secondsStr = "00"
        if seconds > 0 && seconds < 10 {
            secondsStr = "0" + String(seconds)
        } else if seconds >= 10 {
            secondsStr = String(seconds)
        }
        
        return hoursStr + minutesStr + ":" + secondsStr
    }
}
