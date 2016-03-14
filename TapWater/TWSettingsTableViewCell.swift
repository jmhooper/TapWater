import UIKit

class TWSettingsTableViewCell: UITableViewCell {
    // Instance Variables
    var setting: TWSettingsTableViewController.Setting? {
        get {
            return _setting
        } set (newValue) {
            _setting = newValue
            respondToSettingUpdate()
        }
    }
    var _setting: TWSettingsTableViewController.Setting?
    // IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailTextField: UITextField?
}

// MARK: Respond to ivar updates

extension TWSettingsTableViewCell {
    func respondToSettingUpdate() {
        if let setting = setting {
            titleLabel.text = setting.title()
            if let detailTextField = detailTextField {
                detailTextField.text = setting.detail()
                detailTextField.delegate = self
            }
        } else {
            titleLabel.text = nil
            detailTextField?.text = nil
        }
    }
}

// MARK: Goal Editing

extension TWSettingsTableViewCell: UITextFieldDelegate {
    func beginEditingTextField() {
        if let detailTextField = detailTextField {
            if detailTextField.isFirstResponder() {
                return
            }
            detailTextField.userInteractionEnabled = true
            detailTextField.becomeFirstResponder()
        }
    }
    
    func endEditingTextField() {
        if let detailTextField = detailTextField {
            if !detailTextField.isFirstResponder() {
                return
            }
            detailTextField.resignFirstResponder()
            detailTextField.userInteractionEnabled = true
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let newGoal = detailTextFieldNumericValue() {
            
            TWUser.saveCurrentVolumeGoal(newGoal)
        }
        textField.text = "\(TWUser.currentUser().volumeGoal)oz"
    }
    
    private func detailTextFieldNumericValue() -> Int? {
        if let detailTextField = detailTextField,
            let detailTextFieldText = detailTextField.text
        {
            return NSNumberFormatter().numberFromString(
                detailTextFieldText.stringByReplacingOccurrencesOfString(
                    "oz",
                    withString: ""
                )
            )?.integerValue
        }
        return nil
    }
}