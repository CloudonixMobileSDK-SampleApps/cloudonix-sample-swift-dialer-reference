//
//  Settings.swift
//  Cloudonix Example Dialer
//
//  Authors:
//   - Igor Nazarov, 2017-08-15
//   - Oded Arbel, 2022-06-21
//
//  Copyright © 2017 Cloudonix, Inc.
//  Modification, in whole or in part, including copying portions of the work - for use
//  in other software that uses the Cloudonix Mobile SDK - is permitted, without limitation.
//  All other rights reserved.
//

import Foundation

enum Transport: String {
    case UDP
    case TCP
    case TLS
    
    func cloudonixType() -> CloudonixTransportType {
        switch self {
        case .UDP:
            return IOS_TRANSPORT_TYPE_UDP
        case .TCP:
            return IOS_TRANSPORT_TYPE_TCP
        case .TLS:
            return IOS_TRANSPORT_TYPE_TLS
        }
    }
}

class SipSettings {
    private enum Keys: String {
        case server = "server"
        case transport = "transport"
        case port = "port"
        case user = "user"
        case password = "password"
        case displayName = "displayName"
        
        case useRegistration = "useRegistration"
        case useDNS = "useDNS"
        case enableICE = "enableICE"
        
        case useOpus = "useOpus"
        case useG722 = "useG722"
        case useILBC = "useILBC"
        
        case minRate = "minRate"
        case maxRate = "maxRate"
        
        case userAgent = "userAgent"
    }

	var server = "sip.cloudonix.io"
	var domain = "cloudonix.io"
	var transport = Transport.UDP
	var port = "5060"
	var displayName = "97212345678"
	var user = "97212345678"
	var password = "123"

	var useRegistration = true
	var useDNS = false
	var enableICE = true

	var useOpus = true
	var useG722 = false
	var useILBC = false
	
	var minRate = 8000
	var maxRate = 24000

	var userAgent = "CloudonixSwiftExample/1.0"

	static let shared = SipSettings()

    func fetch() {
        let userDefaults = UserDefaults.standard
        
        server = userDefaults.string(forKey: Keys.server.rawValue) ?? server
        if let transportStr = userDefaults.string(forKey: Keys.transport.rawValue) {
            transport = Transport(rawValue: transportStr)!
        }
        port = userDefaults.string(forKey: Keys.port.rawValue) ?? port
        user = userDefaults.string(forKey: Keys.user.rawValue) ?? user
        password = userDefaults.string(forKey: Keys.password.rawValue) ?? password
        displayName = userDefaults.string(forKey: Keys.displayName.rawValue) ?? displayName
        
        useRegistration = userDefaults.bool(forKey: Keys.useRegistration.rawValue)
        useDNS = userDefaults.bool(forKey: Keys.useDNS.rawValue)
        enableICE = userDefaults.bool(forKey: Keys.enableICE.rawValue)
        
        useOpus = userDefaults.bool(forKey: Keys.useOpus.rawValue)
        useG722 = userDefaults.bool(forKey: Keys.useG722.rawValue)
        useILBC = userDefaults.bool(forKey: Keys.useILBC.rawValue)
        
        minRate = userDefaults.integer(forKey: Keys.minRate.rawValue)
        maxRate = userDefaults.integer(forKey: Keys.maxRate.rawValue)
        
        userAgent = userDefaults.string(forKey: Keys.userAgent.rawValue) ?? userAgent
    }
    
    func save() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(server, forKey: Keys.server.rawValue)
        userDefaults.set(transport.rawValue, forKey: Keys.transport.rawValue)
        userDefaults.set(port, forKey: Keys.port.rawValue)
        userDefaults.set(user, forKey: Keys.user.rawValue)
        userDefaults.set(password, forKey: Keys.password.rawValue)
        userDefaults.set(displayName, forKey: Keys.displayName.rawValue)
        
        userDefaults.set(useRegistration, forKey: Keys.useRegistration.rawValue)
        userDefaults.set(useDNS, forKey: Keys.useDNS.rawValue)
        userDefaults.set(enableICE, forKey: Keys.enableICE.rawValue)
        
        userDefaults.set(useOpus, forKey: Keys.useOpus.rawValue)
        userDefaults.set(useG722, forKey: Keys.useG722.rawValue)
        userDefaults.set(useILBC, forKey: Keys.useILBC.rawValue)
        
        userDefaults.set(minRate, forKey: Keys.minRate.rawValue)
        userDefaults.set(maxRate, forKey: Keys.maxRate.rawValue)
        
        userDefaults.set(userAgent, forKey: Keys.userAgent.rawValue)
    }
}

extension SipSettings {
    func valueForRow(_ row: SettingsTableRow) -> Any {
        switch row {
        case .server:
            return server
        case .user:
            return user
        case .displayName:
            return displayName
        case .password:
            return password
            
        case .transport:
            return transport.rawValue
        case .port:
            return port
        case .minRate:
            return String(minRate)
        case .maxRate:
            return String(maxRate)
        case .useDNS:
            return useDNS
        case .enableICE:
            return enableICE
        case .useRegistration:
            return useRegistration
            
        case .useOpus:
            return useOpus
        case .useILBC:
            return useILBC
        case .useG722:
            return useG722
        }
    }
}
