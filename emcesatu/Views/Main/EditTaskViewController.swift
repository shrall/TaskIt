//
//  EditTaskViewController.swift
//  emcesatu
//
//  Created by Marshall Kurniawan on 12/04/22.
//

import UIKit

protocol EditTaskViewControllerDelegate {
    func onUpdate()
}

class EditTaskViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var deadlineSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var diffButtonArray: [UIButton] = []
    var selectedDiff:Int16 = 1
    var deadlineBool = false
    var taskListVC: TaskListViewController!
    var task = TaskItem()
    var oldTask = TaskItem()
    
    var delegate: EditTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    @IBAction func deadlineSwitch(_ sender: UISwitch) {
        self.view.endEditing(true)
        deadlineBool = !deadlineBool
        UIView.animate(withDuration: 0.3, animations: {
            self.datePicker.isHidden = !self.datePicker.isHidden
        })
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        updateItem(task: oldTask, newTask: task)
    }
    @IBAction func nameTFChanged(_ sender: UITextField) {
        if (nameTF.text != "") {
            saveButton.isEnabled = true
            task.name = nameTF.text
        }else{
            saveButton.isEnabled = false
        }
    }
    @IBAction func hardButtonClicked(_ sender: UIButton) {
        toggleDiffButtons(sender)
        task.difficulty = 1
    }
    @IBAction func mediumButtonClicked(_ sender: UIButton) {
        toggleDiffButtons(sender)
        task.difficulty = 3
    }
    @IBAction func easyButtonClicked(_ sender: UIButton) {
        toggleDiffButtons(sender)
        task.difficulty = 5
    }
    
    func toggleDiffButtons(_ theButton:UIButton){
        self.view.endEditing(true)
        for button in diffButtonArray {
            button.layer.borderColor = CGColor(gray: 0, alpha: 0)
        }
        theButton.layer.borderColor = theButton.tintColor.cgColor
    }
    
    func updateItem(task: TaskItem, newTask: TaskItem){
        task.name = nameTF.text
        task.difficulty = newTask.difficulty
        task.deadlineBool = deadlineSwitch.isOn
        task.deadline = datePicker.date
        do{
            try context.save()
        }
        catch{
            
        }
        delegate?.onUpdate()
        self.dismiss(animated: true)
    }
    
    func setup(){
        oldTask = task
        saveButton.isEnabled = true
        nameTF.becomeFirstResponder()
        nameTF.text = task.name
        datePicker.minimumDate = Date()
        diffButtonArray = [hardButton, mediumButton, easyButton]
        for button in diffButtonArray {
            button.layer.borderWidth = 1
            button.layer.borderColor = CGColor(gray: 0, alpha: 0)
        }
        if(task.difficulty == 1){
            hardButton.layer.borderColor = hardButton.tintColor.cgColor
        }else if(task.difficulty == 3){
            mediumButton.layer.borderColor = mediumButton.tintColor.cgColor
        }else{
            easyButton.layer.borderColor = easyButton.tintColor.cgColor
        }
        deadlineSwitch.isOn = task.deadlineBool
        datePicker.isHidden = !task.deadlineBool
        datePicker.date = task.deadline ?? Date()
    }
}
