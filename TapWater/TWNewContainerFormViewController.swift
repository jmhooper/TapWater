import UIKit
import Eureka

class TWNewContainerFormViewController: FormViewController {
    //Outlets
    @IBOutlet var saveButton: UIBarButtonItem!
}

// MARK: View Lifecycle

extension TWNewContainerFormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        buildForm()
        styleView()
    }
}

// MARK: Stylization

extension TWNewContainerFormViewController {
    private func styleView() {
        tableView?.tableFooterView = UIView(frame: CGRectZero)
        tableView?.tintColor = UIColor.tapWaterBlueColor()
        tableView?.backgroundColor = UIColor.tapWaterLightGrayColor()
        tableView?.separatorInset = UIEdgeInsetsZero
        tableView?.layoutMargins = UIEdgeInsetsZero
    }
}

// MARK: Actions

extension TWNewContainerFormViewController {
    @IBAction func cancelButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonPressed() {
        saveContainer()
    }
}

// MARK: Form Elements

extension TWNewContainerFormViewController {
    func buildForm() {
        form +++ Section("Name")
            <<< NameRow("name") { (row) in
                row.title = "Name"
                row.placeholder = "Name"
            }.cellUpdate({ (cell, row) in
                cell.textLabel?.textColor = UIColor.tapWaterDarkGrayColor()
                cell.textField.textColor = UIColor.tapWaterDarkGrayColor()
                cell.textLabel?.font = UIFont.regularTapWaterFontWithSize(16.0)
                cell.textField.font = UIFont.regularTapWaterFontWithSize(16.0)
                cell.layoutMargins = UIEdgeInsetsZero
                cell.contentView.layoutMargins.left = 16.0
            }).onChange({ (row) -> () in
                self.toggleSaveButtonVisibility()
            })
            +++ Section("Volume")
            <<< IntRow("volume") { (row) in
                row.title = "Volume"
                row.placeholder = "Volume"
            }.cellUpdate({ (cell, row) in
                cell.textLabel?.textColor = UIColor.tapWaterDarkGrayColor()
                cell.textField.textColor = UIColor.tapWaterDarkGrayColor()
                cell.textLabel?.font = UIFont.regularTapWaterFontWithSize(16.0)
                cell.textField.font = UIFont.regularTapWaterFontWithSize(16.0)
                cell.layoutMargins = UIEdgeInsetsZero
                cell.contentView.layoutMargins.left = 16.0
            }).onChange({ (row) -> () in
                self.toggleSaveButtonVisibility()
            })
    }
    
    func nameRowValue() -> String? {
        if let nameRow = form.rowByTag("name") as? NameRow {
            return nameRow.value
        }
        return nil
    }
    
    func volumeRowValue() -> Int? {
        if let volumeRow = form.rowByTag("volume") as? IntRow {
            return volumeRow.value
        }
        return nil
    }
}

// MARK: Container Creation

extension TWNewContainerFormViewController {
    func saveContainer() {
        if containerInputIsValid() {
            if let name = nameRowValue(), volume = volumeRowValue() {
                TWContainer.create(name: name, volume: Int64(volume)) { _ in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    func toggleSaveButtonVisibility() {
        if containerInputIsValid() {
            saveButton.enabled = true
            saveButton.tintColor = UIColor.whiteColor()
        } else {
            saveButton.enabled = false
            saveButton.tintColor = UIColor.clearColor()
        }
    }
    
    private func containerInputIsValid() -> Bool {
        if let name = nameRowValue(), volume = volumeRowValue() {
            return name.characters.count > 0 && volume > 0
        }
        return false
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate

extension TWNewContainerFormViewController {
    override func tableView(
        tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 23.0
    }
    
    override func tableView(
        tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let header = TWTableViewSectionHeader()
        header.titleLabel.text = form[section].header?.title
        return header
    }
}