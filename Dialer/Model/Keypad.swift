//
//  File.swift
//  Cloudonix Example Dialer
//
//  Authors:
//   - Igor Nazarov, 2017-08-17
//   - Oded Arbel, 2022-06-21
//
//  Copyright © 2017 Cloudonix, Inc.
//  Modification, in whole or in part, including copying portions of the work - for use
//  in other software that uses the Cloudonix Mobile SDK - is permitted, without limitation.
//  All other rights reserved.
//

import Foundation

enum Keypad: Int {
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    
    case asterisk
    case pound
    
    func title() -> String {
        switch self {
        case .asterisk:
            return "*"
        case .pound:
            return "#"
        default:
            return String(self.rawValue)
        }
    }
    
    func subtitle() -> String? {
        switch self {
        case .zero:
            return "+"
        case .two:
            return "ABC"
        case .three:
            return "DEF"
        case .four:
            return "GHI"
        case .five:
            return "JKL"
        case .six:
            return "MNO"
        case .seven:
            return "PQRS"
        case .eight:
            return "TUV"
        case .nine:
            return "WXYZ"
        default:
            return nil
        }
    }
}
