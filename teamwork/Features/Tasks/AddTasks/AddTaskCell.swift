
import UIKit

protocol AddTaskCellDelegate: class {
    
    func didAddTask(_ cell: AddTaskCell, taskContent: String)
    func didRemoveTask(_ cell: AddTaskCell, taskContent: String)
    
}

class AddTaskCell: UITableViewCell {

    enum Style {
        case add
        case remove
    }
    
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var addRemoveButton: UIButton!
    
    weak var delegate: AddTaskCellDelegate?
    
    var style: Style = .add {
        didSet {
            
            switch style {
            case .add:
                contentTextField.isEnabled = true
                addRemoveButton.setImage(#imageLiteral(resourceName: "add"), for: .normal)
                addRemoveButton.tintColor = UIColor("#60BB46")
            case .remove:
                contentTextField.isEnabled = false
                addRemoveButton.setImage(#imageLiteral(resourceName: "remove"), for: .normal)
                addRemoveButton.tintColor = UIColor("#D6D8D6")
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentTextField.delegate = self
    }
    
    @IBAction func addRemoveAction(_ sender:Any) {
        
        guard let taskContent = contentTextField.text,
            !taskContent.isEmpty else {
            return
        }
        
        switch style {
        case .add:
            delegate?.didAddTask(self, taskContent: taskContent)
            contentTextField.text = nil
        case .remove:
            delegate?.didRemoveTask(self, taskContent: taskContent)
        }
        
    }
}

extension AddTaskCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addRemoveAction(textField)
        return true
    }
    
}
