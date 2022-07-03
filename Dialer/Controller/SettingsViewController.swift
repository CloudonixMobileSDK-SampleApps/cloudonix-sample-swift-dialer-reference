//
//  SettingsViewController.swift
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

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var transportLabel: UILabel!
    @IBOutlet weak var portLabel: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var dnsLabel: UILabel!
    
    @IBOutlet weak var codecsLabel: UILabel!
    @IBOutlet weak var useragentLabel: UILabel!
    @IBOutlet weak var minRateLabel: UILabel!
    @IBOutlet weak var maxRateLabel: UILabel!
    
    @IBOutlet weak var registrationImageView: UIImageView!
    @IBOutlet weak var iceImageView: UIImageView!
    @IBOutlet weak var dnsImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateSettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func onBack() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Utils
    
    func updateSettings() {
        let settings = SipSettings.shared
        
        serverLabel.text = settings.server
        transportLabel.text = settings.transport.rawValue
        portLabel.text = settings.port
        
        userLabel.text = settings.user
        passwordLabel.text = settings.password
        displayNameLabel.text = settings.displayName
        
        let yes = "YES"
        let no = "NO"
        let onImage = UIImage(named: "setting_on")
        let offImage = UIImage(named: "setting_off")
        registrationLabel.text = settings.useRegistration ? yes : no
        registrationImageView.image = settings.useRegistration ? onImage : offImage
        iceLabel.text = settings.enableICE ? yes : no
        iceImageView.image = settings.enableICE ? onImage : offImage
        dnsLabel.text = settings.useDNS ? yes : no
        dnsImageView.image = settings.useDNS ? onImage : offImage
        
        var codecs = [String]()
        if settings.useOpus {
            codecs.append("Opus")
        }
        if settings.useILBC {
            codecs.append("iLBC")
        }
        if settings.useG722 {
            codecs.append("G722")
        }
		let codecsStr = codecs.compactMap({$0}).joined(separator: ", ")
        codecsLabel.text = codecsStr
        useragentLabel.text = settings.userAgent
        minRateLabel.text = String(settings.minRate)
        maxRateLabel.text = String(settings.maxRate)
    }

}
