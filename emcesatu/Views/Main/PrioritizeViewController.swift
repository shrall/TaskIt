//
//  PrioritizeViewController.swift
//  emcesatu
//
//  Created by Marshall Kurniawan on 11/04/22.
//

import UIKit
protocol PrioritizeTaskViewControllerDelegate {
    func onClose()
}

class PrioritizeViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var prioritizeTV: UITableView!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var priorityEmptySV: UIStackView!
    
    var tasks = [TaskItem]()
    var diff = String()
    var diffInt = 1
    var selectedRow = 0
    var delegate: PrioritizeTaskViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prioritizeTV.delegate = self
        prioritizeTV.dataSource = self
        setupNavbarTitle()
        getAllItems(status: "unlisted")
        prioritizeTV.allowsMultipleSelection = true
        prioritizeTV.allowsMultipleSelectionDuringEditing = true
    }
    
    func getAllItems(status:String){
        do{
            tasks = try context.fetch(TaskItem.fetchRequest())
            tasks = tasks.filter{$0.status == status && $0.difficulty == diffInt}
            DispatchQueue.main.async {
                self.prioritizeTV.reloadData()
            }
            if(tasks.count == 0){
                self.prioritizeTV.isHidden = true
                self.priorityEmptySV.isHidden = false
            }else{
                self.prioritizeTV.isHidden = false
                self.priorityEmptySV.isHidden = true
            }
        }
        catch{
            
        }
    }
    @IBAction func doneClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            self.getAllItems(status: "unlisted")
        case 1:
            self.getAllItems(status: "finished")
        default:
            break
        }
    }
    
    @objc func savePriority(){
        print("dor")
    }
    func updateRuled(task: TaskItem, ruledBool: Bool){
        task.ruled = ruledBool
        do{
            try context.save()
        }
        catch{
            
        }
    }
    
    func setupNavbarTitle(){
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        let textLabel = UILabel()
        textLabel.text = diff
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        textLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        
        switch diff {
        case "Hard":
            imageView.image = UIImage(systemName: "1.square")
            imageView.tintColor = Constants.hardColor
            diffInt = 1
        case "Medium":
            imageView.image = UIImage(systemName: "3.square")
            imageView.tintColor = Constants.mediumColor
            diffInt = 3
        case "Easy":
            imageView.image = UIImage(systemName: "5.square")
            imageView.tintColor = Constants.easyColor
            diffInt = 5
        default:
            imageView.image = UIImage(systemName: "1.square")
            imageView.tintColor = Constants.hardColor
        }
        
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.fillProportionally
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 0
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        navBarTitle.titleView = stackView
    }
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.onClose()
    }
}

extension PrioritizeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrioritizeTableViewCell.identifier, for: indexPath) as! PrioritizeTableViewCell
        cell.setup(task: tasks[indexPath.row])
        if(tasks[indexPath.row].ruled == true){
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            cell.setSelected(true, animated: false)
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow += 1
        updateRuled(task: tasks[indexPath.row], ruledBool: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedRow -= 1
        updateRuled(task: tasks[indexPath.row], ruledBool: false)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if selectedRow >= diffInt {
            let alertController = UIAlertController(title: "Oops", message:
                                                        "You are limited to \(diffInt) selection(s)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            
            return nil
        }
        
        return indexPath
    }
}
