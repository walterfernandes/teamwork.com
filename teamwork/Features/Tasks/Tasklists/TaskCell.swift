
import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var responsibleLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var tagsView: UIStackView!
    
    var task: Task? {
        didSet {
            tagsView.subviews.forEach { $0.removeFromSuperview() }

            guard let task = self.task else {
                contentLabel.text = nil
                responsibleLabel.text = nil
                tagsView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                completedButton.isSelected = false
                return
            }
            
            contentLabel.text = task.content
            responsibleLabel.text = task.responsiblePartyNames ?? "Anyone"
            completedButton.tintColor = task.completed ? UIColor("#60BB46") : UIColor("#EEEDE8")
            
            task.tags?.forEach { tagsView.addArrangedSubview(getTagLabel($0)) }
        }
    }
    
    private func getTagLabel(_ tag: Task.Tag) -> UILabel {
        let tagLabel = TWTagLabel()
        tagLabel.text = tag.name
        tagLabel.font = UIFont.systemFont(ofSize: 10)
        tagLabel.textColor = .white
        tagLabel.backgroundColor = UIColor(tag.color)
        tagLabel.cornerRadius = 3
        
        return tagLabel
    }
}
