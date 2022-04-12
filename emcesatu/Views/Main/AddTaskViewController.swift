//
//  AddTaskViewController.swift
//  emcesatu
//
//  Created by Marshall Kurniawan on 08/04/22.
//

import UIKit

protocol AddTaskViewControllerDelegate {
    func onSave()
}

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var deadlineSwitch: UISwitch!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var diffButtonArray: [UIButton] = []
    var selectedDiff:Int16 = 1
    var deadlineBool = false
    var taskListVC: TaskListViewController!
    
    var delegate: AddTaskViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        let newTask = TaskItem(context: context)
        newTask.name = nameTextField.text!
        newTask.difficulty = selectedDiff
        newTask.deadlineBool = deadlineBool
        newTask.deadline = deadlinePicker.date
        newTask.status = "unlisted"
        newTask.createdAt = Date()
        newTask.ruled = false
        do{
            try context.save()
        }
        catch{
            
        }
        delegate?.onSave()
        self.dismiss(animated: true)

    }
    @IBAction func nameTextFieldChanged(_ sender: UITextField) {
        if (nameTextField.text != "") {
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
    }
    @IBAction func easyButtonClicked(_ sender: UIButton) {
        toggleDiffButtons(sender)
        selectedDiff = 5
    }
    @IBAction func mediumButtonClicked(_ sender: UIButton) {
        toggleDiffButtons(sender)
        selectedDiff = 3
    }
    @IBAction func hardButtonClicked(_ sender: UIButton) {
        toggleDiffButtons(sender)
        selectedDiff = 1
    }
    @IBAction func toggleDeadlineSwitch(_ sender: UISwitch) {
        self.view.endEditing(true)
        deadlineBool = !deadlineBool
        UIView.animate(withDuration: 0.3, animations: {
            self.deadlinePicker.isHidden = !self.deadlinePicker.isHidden
        })
    }
    
    func toggleDiffButtons(_ theButton:UIButton){
        self.view.endEditing(true)
        for button in diffButtonArray {
            button.layer.borderColor = CGColor(gray: 0, alpha: 0)
        }
        theButton.layer.borderColor = theButton.tintColor.cgColor
    }
    
    private func setup(){
        nameTextField.becomeFirstResponder()
        deadlinePicker.minimumDate = Date()
        diffButtonArray = [hardButton, mediumButton, easyButton]
        for button in diffButtonArray {
            button.layer.borderWidth = 1
            button.layer.borderColor = CGColor(gray: 0, alpha: 0)
        }
        hardButton.layer.borderColor = hardButton.tintColor.cgColor
        deadlinePicker.isHidden = true
    }
}
