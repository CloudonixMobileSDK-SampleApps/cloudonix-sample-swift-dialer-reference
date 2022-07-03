//
//  KeypadViewController.swift
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

class KeypadViewController: UIViewController {
	@IBOutlet weak var phoneNumberLabel: UILabel!
	@IBOutlet var keypadCollection: Array<UIButton>!

	private var isSDKInitialized = false

	private var callID: String?
	private var incomingCallID: String?
	private var incomingPhoneNumber: String?
	private var app: AppDelegate?;

	override func viewDidLoad() {
		super.viewDidLoad()
		app = UIApplication.shared.delegate as? AppDelegate
		configureKeypad()
		initCloudonixSDK()
	}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isSDKInitialized {
			app!.getClient().add(self)
            register()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
		app!.getClient().remove(self)
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.segue.showActiveCallViewControllerSegue {
            let activeCallViewController = segue.destination as! ActiveCallViewController
            activeCallViewController.phoneNumber = phoneNumberLabel.text
            activeCallViewController.callID = callID
        } else if segue.identifier == Constant.segue.showIncomingCallViewControllerSegue {
            let incomingCallViewController = segue.destination as! IncomingCallViewController
            incomingCallViewController.keypad = self
            incomingCallViewController.callID = incomingCallID
            incomingCallViewController.phoneNumber = incomingPhoneNumber
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onClear() {
        if let phoneNumber = phoneNumberLabel.text {
            if phoneNumber.count > 0 {
                let index = phoneNumber.count - 1
                let newPhoneNumber = phoneNumber.prefix(index)
                
                phoneNumberLabel.text = String(newPhoneNumber)
            }
        }
    }
    
    @IBAction func onKeypad(_ sender: UIButton) {
        guard let keypadItem = Keypad(rawValue: sender.tag) else {
            return
        }
        
        let character: String?
        
        switch keypadItem {
        case .asterisk, .pound:
            character = nil
        default:
            character = keypadItem.title()
        }
        
        if let ch = character {
            if let phoneNumber = phoneNumberLabel.text {
                if phoneNumber.count < 33 {
                    phoneNumberLabel.text?.append(ch)
                }
            }
        }
    }
    
    @IBAction func onCall(_ sender: UIButton) {
        if let phoneNumber = phoneNumberLabel.text {
            if phoneNumber.count > 0 {
                if phoneNumber != SipSettings.shared.user {
                    performSegue(withIdentifier: Constant.segue.showActiveCallViewControllerSegue, sender: self)
                }
            }
        }
    }
    
    // MARK: - Utils
    
    func updateRegistrationState() {
        let user = SipSettings.shared.user
		let state = app!.getClient().isRegistered() ? "Registered" : "Not registered"
        
        title = user + ": " + state
    }
    
    func initCloudonixSDK() {
        if let url = Bundle.main.url(forResource: "license-key", withExtension: "lic") {
            do {
                let data = try Data(contentsOf: url)
                var licenseKey = String(data: data, encoding: .utf8)
                licenseKey = licenseKey?.replacingOccurrences(of: "\n", with: "")

				app!.getClient().initialize(withKey: licenseKey, completion: { [unowned self] (success, error) in
                    if success {
                        self.isSDKInitialized = true
						app!.getClient().add(self)
                        self.setConfigs()
                    } else {
                        self.isSDKInitialized = false
                        
                        print(error?.localizedDescription ?? "Unknown error!")
                    }
                })
            }
            catch {
                print(error.localizedDescription)
            }
		} else {
			showToast(message: "Failed to load SDK license key!",
					  font: .systemFont(ofSize: 20.0), withDuration: 10)
		}
    }

	func setConfigs() {
		if let client = app?.getClient() {
			let settings = SipSettings.shared
			client.setLogLevel(6)
			client.setConfig("USE_OPUS", value: (settings.useOpus ? "1" : "0"))
			client.setConfig("USE_G722", value: (settings.useG722 ? "1" : "0"))
			client.setConfig("USE_ILBC", value: (settings.useILBC ? "1" : "0"))
			client.setConfig("ENABLE_ICE", value: (settings.enableICE ? "1" : "0"))
			client.setConfig("USER_AGENT", value: settings.userAgent)
			client.setConfig("MIN_RATE", value: String(settings.minRate))
			client.setConfig("MAX_RATE", value: String(settings.maxRate))
		}
	}

	func register() {
		let settings = SipSettings.shared
		let regData = CloudonixRegistrationData()
		regData.serverUrl = settings.server
		regData.domain = settings.domain
		regData.displayName = settings.displayName
		regData.username = settings.user
		regData.password = settings.password
		let port = Int(settings.port)!
		regData.port = Int32(port)
		regData.transportType = settings.transport.cloudonixType()
		app!.getClient().setConfiguration(regData)
		app!.getClient().registerAccount();
	}

    func configureKeypad() {
        for button in keypadCollection {
            guard let keypadItem = Keypad(rawValue: button.tag) else {
                return
            }
            
            button.layer.cornerRadius = button.frame.size.width / 2.0
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 2.0
            
            let title = keypadItem.title()
            let subtitle = keypadItem.subtitle()
            
			let attr1 = [NSAttributedString.Key.font : UIFont(name: "OpenSans-Light", size: 38.0), NSAttributedString.Key.foregroundColor : UIColor.white]
			let attr2 = [NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 10.0), NSAttributedString.Key.foregroundColor : UIColor.white]
            
			let str1 = NSAttributedString(string: title, attributes: attr1 as [NSAttributedString.Key : Any])
            let text = NSMutableAttributedString(attributedString: str1)
            
            if subtitle != nil {
				let str2 = NSAttributedString(string: subtitle!, attributes: attr2 as [NSAttributedString.Key : Any])
                text.append(NSAttributedString(string: "\n"))
                text.append(str2)
            }
            
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = NSTextAlignment.center
			button.setAttributedTitle(text, for: UIControl.State())
        }
    }
    
    func startActiveCall() {
        callID = incomingCallID
        
        performSegue(withIdentifier: Constant.segue.showActiveCallViewControllerSegue, sender: self)
    }

	
	func showToast(message : String, font: UIFont, withDuration:TimeInterval) {
		let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
		toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		toastLabel.textColor = UIColor.white
		toastLabel.font = font
		toastLabel.textAlignment = NSTextAlignment.center;
		toastLabel.text = message
		toastLabel.alpha = 1.0
		toastLabel.layer.cornerRadius = 10;
		toastLabel.clipsToBounds  =  true
		self.view.addSubview(toastLabel)
		UIView.animate(withDuration: withDuration, delay: 0.1, options: .curveEaseOut,
					   animations: { toastLabel.alpha = 0.0 },
					   completion: {(isCompleted) in toastLabel.removeFromSuperview()})
	}

}

extension KeypadViewController: CloudonixSDKClientListener {
    
    func onRegisterState(_ result: CloudonixRegistrationState_e, expiry: Int32) {
        DispatchQueue.main.async { [unowned self] in
            self.updateRegistrationState()
        }
    }

	func onSipStarted() {
		self.register()
		let calls = app!.getClient().getCalls() as? [[[VoipCall]]]
		print("Call count:", calls!.count)
	}

    func onCallState(_ callId: String!, callState: CloudonixCallState_e, contactUrl: String!) {
        DispatchQueue.main.async { [unowned self] in
            print("Call state received: %i", callState)
            
            switch callState {
            case IOS_CallState_Incoming:
                self.incomingCallID = callId
                self.incomingPhoneNumber = contactUrl
                
                self.performSegue(withIdentifier: Constant.segue.showIncomingCallViewControllerSegue, sender: self)
                
            default:
                return
            }
        }
    }
}
