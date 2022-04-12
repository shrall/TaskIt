//
//  TaskDetailViewController.swift
//  emcesatu
//
//  Created by Marshall Kurniawan on 12/04/22.
//

import UIKit

protocol TaskDetailViewControllerDelegate {
    func onDelete()
    func onFinished()
}

class TaskDetailViewController: UIViewController {
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDeadline: UILabel!
    @IBOutlet weak var segmentedDescription: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: TaskDetailViewControllerDelegate?
    var task = TaskItem()
    
    let flowtimeHelp =  NSMutableAttributedString()
        .normal("Flowtime is great for task that needs ")
        .bold("a longer period of thinking time ")
        .normal("and")
        .bold(" uses your creativity to finish. ")
        .normal("\n\nEnjoy your task ")
        .bold("without interruption")
        .normal(" while still considering your break time.")
    
    
    let pomodoroHelp = NSMutableAttributedString()
        .normal("Pomodoro is great for task that is ")
        .bold("a chore")
        .normal(" and ")
        .bold("repetitive.")
        .normal("\n\nForce yourself to finish the task by ")
        .bold("weaving your work and break time.")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(task.status == "finished"){
            finishButton.backgroundColor = UIColor(red: 225/255, green: 29/255, blue: 72/255, alpha: 0.2)
            finishButton.tintColor = UIColor(red: 225/255, green: 29/255, blue: 72/255, alpha: 1)
            finishButton.setTitle("Mark unfinished", for: .normal)
        }
        
        segmentedDescription.attributedText = pomodoroHelp
        taskTitle.text = task.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d"
        taskDeadline.text = dateFormatter.string(from: (task.deadline ?? task.createdAt)!)
        taskDeadline.isHidden = !task.deadlineBool
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 108/255, green: 99/255, blue: 255/255, alpha: 1)
        
        let editPullDownButton = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        editPullDownButton.setImage(UIImage(systemName: "ellipsis.rectangle", withConfiguration: largeConfig), for: .normal)
        
        
        let edit = UIAction(title: "Edit Task", image: UIImage(systemName: "pencil"), handler: { _ in self.didTapEdit() })
        let delete = UIAction(title: "Delete Task", image: UIImage(systemName: "trash"), attributes: .destructive ,handler: { _ in self.didTapDelete() })
        let menu = UIMenu(children: [edit, delete])
        editPullDownButton.menu = menu
        
        editPullDownButton.showsMenuAsPrimaryAction = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editPullDownButton)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            segmentedDescription.attributedText = pomodoroHelp
        case 1:
            segmentedDescription.attributedText = flowtimeHelp
        default:
            break
        }
    }
    @IBAction func finishClicked(_ sender: UIButton) {
        if(task.status == "finished"){
            task.status = "unlisted"
        }else{
            task.status = "finished"
        }
        do{
            try context.save()
        }
        catch{
            
        }
        delegate?.onFinished()
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateItem(task: TaskItem, newTask: TaskItem){
        task.name = newTask.name
        task.difficulty = newTask.difficulty
        task.deadlineBool = newTask.deadlineBool
        task.deadline = newTask.deadline
        task.ruled = newTask.ruled
        do{
            try context.save()
        }
        catch{
            
        }
    }
    
    func didTapEdit(){
        
    }
    
    func didTapDelete(){
        context.delete(task)
        do{
            try context.save()
        }
        catch{
            
        }
        delegate?.onDelete()
        self.navigationController?.popViewController(animated: true)
    }
}
