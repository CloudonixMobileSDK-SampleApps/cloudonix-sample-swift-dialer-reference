//
//  IncomingCallViewController.swift
//  Cloudonix Example Dialer
//
//  Authors:
//   - Igor Nazarov, 2017-08-20
//   - Oded Arbel, 2022-06-21
//
//  Copyright © 2017 Cloudonix, Inc.
//  Modification, in whole or in part, including copying portions of the work - for use
//  in other software that uses the Cloudonix Mobile SDK - is permitted, without limitation.
//  All other rights reserved.
//

import UIKit

class IncomingCallViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var callID: String!
    var phoneNumber: String!
    
    var keypad: KeypadViewController!
	var app:AppDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
		app = UIApplication.shared.delegate as? AppDelegate
        phoneNumberLabel.text = phoneNumber
        
		app?.getClient().add(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    
    @IBAction func onAnswer(_ sender: UIButton) {
		app?.getClient().answer(callID)
        
        let keypadViewController = self.keypad
        self.dismiss(animated: true, completion: {
            keypadViewController!.startActiveCall()
        })
    }
    
    @IBAction func onDecline(_ sender: UIButton) {
		app?.getClient().reject(callID)
        self.dismiss(animated: true, completion: nil)
    }

}

extension IncomingCallViewController: CloudonixSDKClientListener {
    
    func onCallState(_ callId: String!, callState: CloudonixCallState_e, contactUrl: String!) {
        DispatchQueue.main.async { [unowned self] in
            print("Call state received: %i", callState)
            
            switch callState {
            case IOS_CallState_Disconnected, IOS_CallState_DisconnectedDueToBusy, IOS_CallState_DisconnectedDueToNoMedia, IOS_CallState_DisconnectedDueToTimeout, IOS_CallState_DisconnectedMediaChanged, IOS_CallState_DisconnectedDueToNetworkChange:
                self.dismiss(animated: true, completion: nil)
                
            case IOS_CallState_Confirmed:
                let keypadViewController = self.keypad
                
                self.dismiss(animated: true, completion: {
                    keypadViewController!.startActiveCall()
                })
                
            default:
                return
            }
        }
    }
}
