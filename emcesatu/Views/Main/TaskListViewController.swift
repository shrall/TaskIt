//
//  TaskListViewController.swift
//  emcesatu
//
//  Created by Marshall Kurniawan on 08/04/22.
//

import UIKit

class TaskListViewController: UIViewController{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let navbarTitle = UILabel()
    @IBOutlet weak var taskTV: UITableView!
    @IBOutlet weak var emptySV: UIStackView!
    @IBOutlet weak var taskSC: UISegmentedControl!
    
    private var tasks = [TaskItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems(status: "unlisted")
        taskTV
            .delegate = self
        taskTV
            .dataSource = self
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.square", withConfiguration: largeConfig), style: .plain, target: self, action: #selector(self.openAddTaskModal))
        addButton.tintColor = UIColor(red: 108/255, green: 99/255, blue: 255/255, alpha: 1)
        
        navbarTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 32.0)
        navbarTitle.text = "Task List";
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: navbarTitle)
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func openAddTaskModal(){
        let controller = storyboard?.instantiateViewController(withIdentifier:"addTaskVC") as! AddTaskViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func getAllItems(status:String){
        do{
            tasks = try context.fetch(TaskItem.fetchRequest())
            tasks = tasks.filter{$0.status == status}
            DispatchQueue.main.async {
                self.taskTV.reloadData()
            }
            if(tasks.count == 0){
                self.taskTV.isHidden = true
                self.emptySV.isHidden = false
            }else{
                self.taskTV.isHidden = false
                self.emptySV.isHidden = true
            }
        }
        catch{
            
        }
    }
    @IBAction func taskSCChanged(_ sender: UISegmentedControl) {
        switch taskSC.selectedSegmentIndex
        {
        case 0:
            self.getAllItems(status: "unlisted")
        case 1:
            self.getAllItems(status: "finished")
        default:
            break
        }
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
    
    func deleteItem(item: TaskItem){
        context.delete(item)
        do{
            try context.save()
        }
        catch{
            
        }
    }
    
}
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        cell.setup(tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        deleteItem(item: tasks[indexPath.row])
        getAllItems(status: "unlisted")
    }
}
extension TaskListViewController: AddTaskViewControllerDelegate{
    func onSave() {
        getAllItems(status: "unlisted")
    }
}
