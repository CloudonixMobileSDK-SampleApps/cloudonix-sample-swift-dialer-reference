//
//  EditSettingsViewController.swift
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

import UIKit

enum SettingsTableSection: Int {
    case credentials
    case configurations
    case codecs
    
    func getTitle() -> String? {
        switch self {
        case .credentials:
            return nil
        case .configurations:
            return "Configure transport"
        case .codecs:
            return "Configure codecs"
        }
    }
}

enum SettingsTableRow: Int {
    case server
    case user
    case displayName
    case password
    
    case transport
    case port
    case minRate
    case maxRate
    case useDNS
    case enableICE
    case useRegistration
    
    case useOpus
    case useILBC
    case useG722
    
    func cellType() -> UITableViewCell.Type {
        switch self {
        case .server:
            return SettingsTextTableViewCell.self
        default:
            return SettingsSwitchTableViewCell.self
        }
    }
    
    func getInfo() -> (title: String, cellIdentifier: String, isTextCell: Bool, isTextEditingEnabled: Bool) {
        let textCell = String(describing: SettingsTextTableViewCell.self)
        let switchCell = String(describing: SettingsSwitchTableViewCell.self)
        
        switch self {
        case .server:
            return ("Server address", textCell, true, true)
        case .user:
            return ("Authentication user", textCell, true, true)
        case .displayName:
            return ("Display name", textCell, true, true)
        case .password:
            return ("Authentication password", textCell, true, true)
            
        case .transport:
            return ("Transport type", textCell, true, false)
        case .port:
            return ("Transport port", textCell, true, true)
        case .minRate:
            return ("Minimal audio bitrate", textCell, true, false)
        case .maxRate:
            return ("Maximal audio bitrate", textCell, true, false)
        case .useDNS:
            return ("Use DNS-SRV", switchCell, false, false)
        case .enableICE:
            return ("Enable ICE", switchCell, false, false)
        case .useRegistration:
            return ("Use registration", switchCell, false, false)
            
        case .useOpus:
            return ("Enable Opus codec", switchCell, false, false)
        case .useILBC:
            return ("Enable iLBC codec", switchCell, false, false)
        case .useG722:
            return ("Enable G722 codec", switchCell, false, false)
        }
    }
    
    func getPickerType() -> PickerViewType? {
        switch self {
        case .transport:
            return .transport
        case .minRate:
            return .minRate
        case .maxRate:
            return .maxRate
        default:
            return nil
        }
    }
}

struct Settings {
    var type: SettingsTableSection
    var items: [SettingsTableRow]
}

enum PickerViewType {
    case transport
    case minRate
    case maxRate
    
    var pickerData: [String] {
        get {
            switch self {
            case .transport:
                return ["UDP", "TCP", "TLS"]
                
            case .minRate, .maxRate:
                return ["8000", "12000", "16000", "24000"]
            }
        }
    }
}

class EditSettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var pickerViewTopConstraint: NSLayoutConstraint!
    
    var settings = [Settings(type: .credentials, items: [.server, .user, .displayName, .password]),
                    Settings(type: .configurations, items: [.transport, .port, .minRate, .maxRate, .useDNS, .enableICE, .useRegistration]),
                    Settings(type: .codecs, items: [.useOpus, .useILBC, .useG722])]
    var sipSettings = SipSettings.shared
    
    var pickerType: PickerViewType = .transport {
        didSet {
            pickerData = pickerType.pickerData
            
            if pickerType == .maxRate {
                let minRate = (sipSettings.minRate)
                pickerData = pickerData.filter() {
                    let rate = (Int($0))!
                    return rate >= minRate
                }
            }
            
            pickerView.reloadAllComponents()
        }
    }
    var pickerData = [String]()
    
    var activeTextField: UITextField? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sipSettings.save()
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func onBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onTextFieldTextDidChange(textField: UITextField) {
        if let newText = textField.text {
            switch textField.tag {
            case SettingsTableRow.server.rawValue:
                sipSettings.server = newText
                
            case SettingsTableRow.user.rawValue:
                sipSettings.user = newText
                
            case SettingsTableRow.displayName.rawValue:
                sipSettings.displayName = newText
                
            case SettingsTableRow.password.rawValue:
                sipSettings.password = newText
                
            case SettingsTableRow.port.rawValue:
                sipSettings.port = newText
                
            default:
                return
            }
        }
    }
    
    @objc func onSwitchValueDidChange(switchControl: UISwitch) {
        let isOn = switchControl.isOn
        
        switch switchControl.tag {
        case SettingsTableRow.useDNS.rawValue:
            sipSettings.useDNS = isOn
            
        case SettingsTableRow.enableICE.rawValue:
            sipSettings.enableICE = isOn
            
        case SettingsTableRow.useRegistration.rawValue:
            sipSettings.useRegistration = isOn
            
        case SettingsTableRow.useOpus.rawValue:
            sipSettings.useOpus = isOn
            
        case SettingsTableRow.useILBC.rawValue:
            sipSettings.useILBC = isOn
            
        case SettingsTableRow.useG722.rawValue:
            sipSettings.useG722 = isOn
            
        default:
            return
        }
    }
    
    @IBAction func onPickerDone() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedSetting = pickerData[selectedRow]
        
        switch pickerType {
        case .transport:
            if let transport = Transport(rawValue: selectedSetting) {
                sipSettings.transport = transport
            }
            
        case .minRate:
            if let rate = Int(selectedSetting) {
                sipSettings.minRate = rate
            }
            
        case .maxRate:
            if let rate = Int(selectedSetting) {
                sipSettings.maxRate = rate
            }
        }
        
        settingsTableView.reloadData()
        showPicker(false)
    }
    
    // MARK: - Utils
    
    func showPicker(_ show: Bool) {
        pickerViewTopConstraint.constant = show ? -pickerView.frame.size.height : 0
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

}

// MARK: - UITableViewDataSource

extension EditSettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionType = settings[section].type
        return sectionType.getTitle()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingItem = settings[indexPath.section].items[indexPath.row]
        let (title, identifier, isTextCell, isTextEditingEnabled) = settingItem.getInfo()
        
        var cell: UITableViewCell
        
        if isTextCell {
            let textCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! SettingsTextTableViewCell
            textCell.title = title
			textCell.value = sipSettings.valueForRow(settingItem) as? String
            textCell.textField.delegate = self
            textCell.textField.tag = settingItem.rawValue
            textCell.textField.addTarget(self, action: #selector(onTextFieldTextDidChange(textField:)), for: .editingChanged)
            textCell.textField.isEnabled = isTextEditingEnabled
            
            cell = textCell
        } else {
            let switchCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! SettingsSwitchTableViewCell
            switchCell.title = title
            switchCell.isOn = sipSettings.valueForRow(settingItem) as! Bool
            switchCell.enableSwitch.tag = settingItem.rawValue
            switchCell.enableSwitch.addTarget(self, action: #selector(onSwitchValueDidChange(switchControl:)), for: .valueChanged)
            
            cell = switchCell
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension EditSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red: 142.0 / 255.0, green: 142.0 / 255.0, blue: 142.0 / 255.0, alpha: 1.0)
        header.textLabel?.font = UIFont(name: "OpenSans-Semibold", size: 17.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingItem = settings[indexPath.section].items[indexPath.row]
        
        if settingItem == .transport || settingItem == .minRate || settingItem == .maxRate {
            if let type = settingItem.getPickerType() {
                pickerType = type
                
                if activeTextField != nil {
                    activeTextField?.resignFirstResponder()
                }
                showPicker(true)
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension EditSettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

// MARK: - UIPickerViewDataSource

extension EditSettingsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
}

// MARK: - UIPickerViewDelegate

extension EditSettingsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}



