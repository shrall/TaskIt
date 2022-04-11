//
//  OnboardingCollectionViewCell.swift
//  emcesatu
//
//  Created by Marshall Kurniawan on 08/04/22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDeadline: UILabel!
    @IBOutlet weak var taskDifficultyIcon: UIImageView!
    @IBOutlet weak var taskDifficultyLabel: UILabel!
    
    static let identifier = "taskCell"
    let hardIcon = UIImage(systemName: "die.face.1")
    let mediumIcon = UIImage(systemName: "die.face.3")
    let easyIcon = UIImage(systemName: "die.face.5")
    let hardColor = UIColor(red: 225/255, green: 29/255, blue: 72/255, alpha: 1)
    let mediumColor = UIColor(red: 251/255, green: 187/255, blue: 2/255, alpha: 1)
    let easyColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1)
    
    
    func setup(_ task:TaskItem){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d"
        taskTitle.text = task.name
        taskDeadline.text = dateFormatter.string(from: (task.deadline ?? task.createdAt)!)
        taskDeadline.isHidden = !task.deadlineBool
        switch task.difficulty {
        case 1:
            taskDifficultyLabel.text = "Hard"
            taskDifficultyIcon.image = hardIcon
            taskDifficultyLabel.textColor = hardColor
            taskDifficultyIcon.tintColor = hardColor
        case 3:
            taskDifficultyLabel.text = "Medium"
            taskDifficultyIcon.image = mediumIcon
            taskDifficultyLabel.textColor = mediumColor
            taskDifficultyIcon.tintColor = mediumColor
        default:
            taskDifficultyLabel.text = "Easy"
            taskDifficultyIcon.image = easyIcon
            taskDifficultyLabel.textColor = easyColor
            taskDifficultyIcon.tintColor = easyColor
        }
    }
}
