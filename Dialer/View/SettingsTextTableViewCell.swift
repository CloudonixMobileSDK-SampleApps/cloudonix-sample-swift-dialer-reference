//
//  SettingsTextTableViewCell.swift
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

class SettingsTextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var value: String? {
        didSet {
            textField.text = value
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
