//
//  ActiveCallViewController.swift
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

class ActiveCallViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var callDurationLabel: UILabel!
    
    @IBOutlet weak var muteLabel: UILabel!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var holdLabel: UILabel!
    
    let kTimerUpdateInterval = 1.0
    var time = 0.0
    var timer: Timer? = nil
    
    var phoneNumber: String!
    var callID: String? = nil
    
    var isMuted = false {
        didSet {
            updateMuteState()
        }
    }
    var isHold = false {
        didSet {
            updateHoldState()
        }
    }
    var isSpeaker = false
	private var app: AppDelegate?;

    override func viewDidLoad() {
        super.viewDidLoad()
		app = UIApplication.shared.delegate as? AppDelegate

        phoneNumberLabel.text = phoneNumber
        
		app?.getClient().add(self)
        if callID == nil {
			app?.getClient().dial(phoneNumber)
        } else {
            startTimer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
		app?.getClient().remove(self)
        super.viewWillDisappear(animated)
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
    
    @IBAction func onHangup(_ sender: UIButton) {
		app?.getClient().hangup(callID)
    }
    
    @IBAction func onHold(_ sender: UIButton) {
		app?.getClient().localHold(callID, enable: !isHold)
    }
    
    @IBAction func onMute(_ sender: UIButton) {
        isMuted = !isMuted
		app?.getClient().mute(isMuted)
    }
    
	@IBAction func onSpeaker(_ sender: UIButton) {
		isSpeaker = !isSpeaker
		let route = (isSpeaker ? kAudioSessionManagerDevice_Speaker : kAudioSessionManagerDevice_Phone) as NSString;
		app?.getClient().audioSession.audioRoute = route;
	}

}

private typealias TimerUtils = ActiveCallViewController
private extension TimerUtils {
    
    func startTimer() {
        if timer == nil {
            if #available(iOS 10.0, *) {
                timer = Timer.scheduledTimer(withTimeInterval: kTimerUpdateInterval, repeats: true) { [unowned self] (timer) in
                    self.timerFired()
                }
            } else {
                timer = Timer.scheduledTimer(timeInterval: kTimerUpdateInterval, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func timerFired() {
        time += kTimerUpdateInterval
        callDurationLabel.text = time.toTimeString()
    }
}

private typealias UIUtils = ActiveCallViewController
private extension UIUtils {
    
    func updateMuteState() {
        muteLabel.text = isMuted ? "UNMUTE" : "MUTE"
		muteButton.setImage(UIImage(named: (isMuted ? "unmute" : "mute")), for: UIControl.State())
    }
    
    func updateHoldState() {
        holdLabel.text = isHold ? "UNHOLD" : "HOLD"
    }
}

extension ActiveCallViewController: CloudonixSDKClientListener {
    
    func onCallState(_ callId: String!, callState: CloudonixCallState_e, contactUrl: String!) {
        DispatchQueue.main.async { [unowned self] in
            print("Call state received: %i", callState)
            self.callID = callId
            
            switch callState {
            case IOS_CallState_Disconnected, IOS_CallState_DisconnectedDueToBusy, IOS_CallState_DisconnectedDueToNoMedia, IOS_CallState_DisconnectedDueToTimeout, IOS_CallState_DisconnectedMediaChanged, IOS_CallState_DisconnectedDueToNetworkChange:
                self.stopTimer()
                self.dismiss(animated: true, completion: nil)
                
            case IOS_CallState_Confirmed:
                self.startTimer()
                
            case IOS_CallState_LocalHold:
                self.isHold = true
                
            case IOS_CallState_MediaActive:
                self.isHold = false
                
            default:
                return
            }
        }
    }
}
