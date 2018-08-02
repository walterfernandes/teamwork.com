
import UIKit

class TasklistHeaderView: UITableViewHeaderFooterView {

    static var reuseIdentifier: String? {
        return "TasklistHeaderView"
    }
    
    var titleLabel: UILabel
    var addTasksButton: UIButton
    
    override init(reuseIdentifier: String?) {
        
        titleLabel = UILabel()
        addTasksButton = UIButton()
        
        super.init(reuseIdentifier: reuseIdentifier)
        initSubViews()
        initConstraits()
    }
    
    func initSubViews() {
        backgroundColor = UIColor("#EEEDE8")

        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        titleLabel.textColor = UIColor("#161616")
        
        addTasksButton.backgroundColor = UIColor("#60BB46")
        addTasksButton.clipsToBounds = true
        addTasksButton.cornerRadius = 5
        addTasksButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        addTasksButton.setTitle("Add Tasks", for: .normal)
        addTasksButton.setTitleColor(UIColor("#FBFBF8"), for: .normal)
        addTasksButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        addSubview(titleLabel)
        addSubview(addTasksButton)
    }
    
    func initConstraits() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor).isActive = true

        addTasksButton.translatesAutoresizingMaskIntoConstraints = false
        addTasksButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        addTasksButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        addTasksButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor).isActive = true
        addTasksButton.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 10).isActive = true
        
        addTasksButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
