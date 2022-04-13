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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDeadline: UILabel!
    @IBOutlet weak var segmentedDescription: UILabel!
    @IBOutlet weak var taskTimer: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var breakButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: TaskDetailViewControllerDelegate?
    var task = TaskItem()
    var timerType = 0
    
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    var counter: Int = 0
    
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
    
    var motivationalQuotes = [
        NSMutableAttributedString().italic("There is nothing impossible to they who will try.").bold("\n\n— Alexander the Great"),
        NSMutableAttributedString().italic("Success is not final, failure is not fatal.\nIt is the courage to continue that counts.").bold("\n\n– Winston Churchill"),
        NSMutableAttributedString().italic("The best revenge is massive success.").bold("\n\n– Frank Sinatra"),
        NSMutableAttributedString().italic("We are what we repeatedly do.\nExcellence then, is not an act, but a habit.").bold("\n\n– Aristotle"),
        NSMutableAttributedString().italic("The only way to do great work is to love what you do.\nIf you haven’t found it yet, keep looking. Don’t settle.").bold("\n\n– Steve Jobs"),
        NSMutableAttributedString().italic("Working hard for something we don’t care about is called stress.\nWorking hard for something we love is called passion.").bold("\n\n– Simon Sinek"),
        NSMutableAttributedString().italic("The secret of change is to focus all of your energy not on fighting the old, but on building the new.").bold("\n\n– Socrates"),
        NSMutableAttributedString().italic("If you get tired, learn to rest, not to quit.").bold("\n\n– Banksy")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTimer.isHidden = true
        breakButton.isHidden = true
        if(task.status == "finished"){
            finishButton.backgroundColor = UIColor(red: 225/255, green: 29/255, blue: 72/255, alpha: 0.2)
            finishButton.tintColor = UIColor(red: 225/255, green: 29/255, blue: 72/255, alpha: 1)
            finishButton.setTitle("Mark unfinished", for: .normal)
        }
        
        segmentedDescription.attributedText = pomodoroHelp
        taskTitle.text = task.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, YYYY"
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
            timerType = 0
        case 1:
            segmentedDescription.attributedText = flowtimeHelp
            timerType = 1
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
    
    func didTapEdit(){
        let editVC = (storyboard?.instantiateViewController(withIdentifier:"editTaskVC")) as! EditTaskViewController
        editVC.task = task
        editVC.delegate = self
        self.present(editVC, animated: true)
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
    @IBAction func breakButtonClicked(_ sender: Any) {
        if(timerCounting)
        {
            switch timerType {
            case 0:
                
                timer.invalidate()
                //break
                timerCounting = false
                breakButton.setTitle("Start Working", for: .normal)
                breakButton.tintColor = UIColor(red: 108/255, green: 99/255, blue: 255/255, alpha: 1)
                
                var breaktime = 0
                if(counter < 4)
                {
                    taskTimer.text = makeTimeString(hours: 0, minutes: 5, seconds: 0)
                    breaktime = 5 * 60
                    counter += 1
                }else
                {
                    taskTimer.text = makeTimeString(hours: 0, minutes: 15, seconds: 0)
                    breaktime = 15 * 60
                    counter = 0
                }
                count = breaktime
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerWatch), userInfo: nil, repeats: true)
            case 1:
                timer.invalidate()
                //break
                timerCounting = false
                breakButton.setTitle("Start Working", for: .normal)
                breakButton.tintColor = UIColor(red: 108/255, green: 99/255, blue: 255/255, alpha: 1)
                
                var breaktime = 0
                if(count < 25 * 60)
                {
                    taskTimer.text = makeTimeString(hours: 0, minutes: 5, seconds: 0)
                    breaktime = 5 * 60
                }else if(count >= 25 * 60 && count < 50 * 60)
                {
                    taskTimer.text = makeTimeString(hours: 0, minutes: 8, seconds: 0)
                    breaktime = 8 * 60
                }else if(count >= 50 * 60 && count < 90 * 60)
                {
                    taskTimer.text = makeTimeString(hours: 0, minutes: 10, seconds: 0)
                    breaktime = 10 * 60
                }else
                {
                    taskTimer.text = makeTimeString(hours: 0, minutes: 15, seconds: 0)
                    breaktime = 15 * 60
                }
                count = breaktime
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerWatch), userInfo: nil, repeats: true)
            default:
                break
            }
        }else{
            switch timerType {
            case 0:
                startPomodoro()
            case 1:
                startFlowtime()
            default:
                break
            }
        }
    }
    @IBAction func timerButtonClicked(_ sender: Any) {
        timerButton.isHidden = !timerCounting
        taskTimer.isHidden = timerCounting
        segmentedControl.isEnabled = timerCounting
        breakButton.isHidden = timerCounting
        segmentedDescription.attributedText = motivationalQuotes[Int(arc4random_uniform(UInt32(motivationalQuotes.count)))]
        switch timerType {
        case 0:
            startPomodoro()
        case 1:
            startFlowtime()
        default:
            break
        }
    }
    func startFlowtime(){
        if(!timerCounting){
            timer.invalidate()
            //stopwatch
            timerCounting = true
            breakButton.setTitle("Take A Break", for: .normal)
            breakButton.tintColor = UIColor(red: 225/255, green: 29/255, blue: 72/255, alpha: 1)
            count = 0
            taskTimer.text = makeTimeString(hours: 0, minutes: 0, seconds: 0)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stopWatch), userInfo: nil, repeats: true)
        }
    }
    func startPomodoro(){
        if(!timerCounting)
        {
            timer.invalidate()
            //timer
            timerCounting = true
            breakButton.setTitle("Take A Break", for: .normal)
            breakButton.tintColor = UIColor(red: 225/255, green: 29/255, blue: 72/255, alpha: 1)
            taskTimer.text = makeTimeString(hours: 0, minutes: 25, seconds: 0)
            count = 25 * 60
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerWatch), userInfo: nil, repeats: true)
        }
    }
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
    {
        return ((seconds / 3600), ((seconds % 3600)/60), ((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    @objc func stopWatch() -> Void
    {
        count += 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        taskTimer.text = timeString
    }
    
    @objc func timerWatch() -> Void
    {
        if(count > 0)
        {
            count = count - 1
        }
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        taskTimer.text = timeString
    }
}

extension TaskDetailViewController: EditTaskViewControllerDelegate{
    func onUpdate() {
        taskTitle.text = task.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, YYYY"
        taskDeadline.text = dateFormatter.string(from: (task.deadline ?? task.createdAt)!)
        taskDeadline.isHidden = !task.deadlineBool
    }
}
