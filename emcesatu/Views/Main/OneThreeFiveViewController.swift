//
//  OneThreeFiveViewController.swift
//  emcesatu
//
//  Created by Marshall Kurniawan on 08/04/22.
//

import UIKit

class OneThreeFiveViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var otfTV: UITableView!
    
    let navbarTitle = UILabel()

    private var hardTasks = [TaskItem]()
    private var mediumTasks = [TaskItem]()
    private var easyTasks = [TaskItem]()
    private var tasks = [TaskItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        otfTV.delegate = self
        otfTV.dataSource = self
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        let helpButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.square", withConfiguration: largeConfig), style: .plain, target: self, action: #selector(self.openOneThreeFiveHelpModal))
        helpButton.tintColor = UIColor(red: 108/255, green: 99/255, blue: 255/255, alpha: 1)
        
        navbarTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 32.0)
        navbarTitle.text = "Today's 1-3-5";
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: navbarTitle)
        self.navigationItem.rightBarButtonItem = helpButton
    }
    @objc func openOneThreeFiveHelpModal(){
        let controller = storyboard?.instantiateViewController(withIdentifier:"oneThreeFiveVC") as! UIViewController
        self.present(controller, animated: true, completion: nil)
    }
    func getAllItems(){
        do{
            tasks = try context.fetch(TaskItem.fetchRequest())
            
            hardTasks = tasks.filter{$0.difficulty == 1}
            mediumTasks = tasks.filter{$0.difficulty == 3}
            easyTasks = tasks.filter{$0.difficulty == 5}
            DispatchQueue.main.async {
                self.otfTV.reloadData()
            }
        }
        catch{
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getAllItems()
    }
}

extension OneThreeFiveViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return hardTasks.count
        case 1:
            return mediumTasks.count
        case 2:
            return easyTasks.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OneThreeFiveTableViewCell.identifier, for: indexPath) as! OneThreeFiveTableViewCell
        switch indexPath.section {
        case 0:
            cell.setup(task: hardTasks[indexPath.row])
            return cell
        case 1:
            cell.setup(task: mediumTasks[indexPath.row])
            return cell
        case 2:
            cell.setup(task: easyTasks[indexPath.row])
            return cell
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        let textLabel = UILabel()
        textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        textLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        
        switch section {
        case 0:
            imageView.image = UIImage(systemName: "1.square")
            imageView.tintColor = Constants.hardColor
            textLabel.text  = "Hard"
        case 1:
            imageView.image = UIImage(systemName: "3.square")
            imageView.tintColor = Constants.mediumColor
            textLabel.text  = "Medium"
        case 2:
            imageView.image = UIImage(systemName: "5.square")
            imageView.tintColor = Constants.easyColor
            textLabel.text  = "Easy"
        default:
            imageView.image = UIImage(systemName: "1.square")
            imageView.tintColor = Constants.hardColor
        }
        
        let editButton = UIButton()
        
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 16.0

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.contentView.addSubview(stackView)
            
    NSLayoutConstraint.activate([
        stackView.leadingAnchor.constraint(equalTo: headerView.contentView.leadingAnchor, constant: 0),
        stackView.trailingAnchor.constraint(equalTo: headerView.contentView.trailingAnchor, constant: -16),
        stackView.topAnchor.constraint(equalTo: headerView.contentView.topAnchor, constant: 12),
        stackView.bottomAnchor.constraint(equalTo:headerView.contentView.bottomAnchor, constant: -12)
    ])
            
        return headerView
    }
}
