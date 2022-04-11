//
//  OneThreeFiveTableViewCell.swift
//  emcesatu
//
//  Created by Marshall Kurniawan on 11/04/22.
//

import UIKit

class OneThreeFiveTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDeadline: UILabel!
    @IBOutlet weak var doneIcon: UIImageView!
    
    static let identifier = "otfCell"
    
    func setup(task: TaskItem){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d"
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: task.name!)
        taskDeadline.text = dateFormatter.string(from: (task.deadline ?? task.createdAt)!)
        taskDeadline.isHidden = !task.deadlineBool
        
        if(task.status == "finished"){
            doneIcon.isHidden = false
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            taskTitle.textColor = UIColor(red: 108/255, green: 99/255, blue: 255/255, alpha: 1)
        }else{
            doneIcon.isHidden = true
            taskTitle.textColor = UIColor.label
        }
        taskTitle.attributedText = attributeString
    }
}
