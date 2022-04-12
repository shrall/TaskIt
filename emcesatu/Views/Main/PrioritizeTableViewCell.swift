//
//  PrioritizeTableViewCell.swift
//  emcesatu
//
//  Created by Marshall Kurniawan on 11/04/22.
//

import UIKit

protocol PrioritizeTaskViewControllerDelegate {
    func onClose()
}

class PrioritizeTableViewCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDeadline: UILabel!
    static let identifier = "prioritizeCell"
    
    func setup(task: TaskItem){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d"
        taskDeadline.text = dateFormatter.string(from: (task.deadline ?? task.createdAt)!)
        taskDeadline.isHidden = !task.deadlineBool
        taskName.text = task.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
