//
//  RegistrationViewController.swift
//  Hotel Manzana
//
//  Created by Denis Bystruev on 18/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class RegistrationViewController: UITableViewController {
    // MARK: Outlets
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    @IBOutlet var numberOfAdultsLabel: UILabel!
    @IBOutlet var numberOfAdultsStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    @IBOutlet var wifiSwitch: UISwitch!
    @IBOutlet var roomTypeLabel: UILabel!
    
    // MARK: - Properties
    let checkInDateLabelIndexPath = IndexPath(row: 0, section: 1)
    let checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDateLabelIndexPath = IndexPath(row: 2, section: 1)
    let checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    let roomTypeSelectionIndexPath = IndexPath(row: 0, section: 4)
    
    var isCheckInDatePickerShown = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    var isCheckOutDatePickerShown = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    var selectedRoom: RoomType? {
        didSet {
            roomTypeLabel.text = selectedRoom?.name
        }
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkInDatePicker.isHidden = true
        checkOutDatePicker.isHidden = true
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        updateDateViews()
        updateNumberOfGuests()
    }
    
    // MARK: - Custom Methods
    func updateDateViews() {
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(60 * 60 * 24)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale.current
        
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    
    // MARK: - Actions
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        var registration = Registration()
        registration.firstName = firstNameTextField.text ?? ""
        registration.lastName = lastNameTextField.text ?? ""
        registration.emailAddress = emailTextField.text ?? ""
        registration.checkInDate = checkInDatePicker.date
        registration.checkOutDate = checkOutDatePicker.date
        registration.numberOfAdults = Int(numberOfAdultsStepper.value)
        registration.numberOfChildren = Int(numberOfChildrenStepper.value)
        registration.wifi = wifiSwitch.isOn
        if let selectedRoom = selectedRoom { registration.roomType = selectedRoom }
        
        print(#line, #function, registration)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension RegistrationViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
            
        case checkInDatePickerIndexPath:
            return isCheckInDatePickerShown ? UITableView.automaticDimension : 0
            
        case checkOutDatePickerIndexPath:
            return isCheckOutDatePickerShown ? UITableView.automaticDimension : 0
            
        default:
            return UITableView.automaticDimension
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
            
        case checkInDateLabelIndexPath:
            isCheckInDatePickerShown.toggle()
            if isCheckInDatePickerShown {
                isCheckOutDatePickerShown = false
            }
            
        case checkOutDateLabelIndexPath:
            isCheckOutDatePickerShown.toggle()
            if isCheckOutDatePickerShown {
                isCheckInDatePickerShown = false
            }
            
        case roomTypeSelectionIndexPath:
            let controller = storyboard!.instantiateViewController(withIdentifier: "RoomTypeID") as! RoomTypeViewController
            controller.selectedRoom = selectedRoom
            navigationController?.pushViewController(controller, animated: true)
            
        default:
            return
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
}
