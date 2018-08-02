
import UIKit
import PKHUD

protocol AddTasksViewControllerDelegate: class {
    func didSaveTasks(_ addTasksViewController: AddTasksViewController)
}

class AddTasksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let presenter = AddTasksPresenter()
    private var newTasks = [String]()
    
    weak var delegate: AddTasksViewControllerDelegate?
    var tasklist: Tasklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        
        tableView.keyboardDismissMode = .onDrag
    }

    @IBAction func saveAction(_ sender: Any) {
        presenter.saveTasks(newTasks, tasklistId: tasklist.id, projectId: tasklist.projectId)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddTasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newTasks.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskCell", for: indexPath) as! AddTaskCell
        
        cell.delegate = self
        
        if indexPath.row == 0 {
            cell.style = .add
            cell.contentTextField.text = ""
            cell.contentTextField.becomeFirstResponder()
        } else {
            cell.style = .remove
            cell.contentTextField.text = newTasks[indexPath.row-1]
        }
        
        return cell
    }
    
}

extension AddTasksViewController: AddTaskCellDelegate {

    func didAddTask(_ cell: AddTaskCell, taskContent: String) {
        newTasks.insert(taskContent, at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath.init(row: 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func didRemoveTask(_ cell: AddTaskCell, taskContent: String) {
        if let index = newTasks.index(of: taskContent) {
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: index + 1, section: 0)], with: .automatic)
            newTasks.remove(at: index)
            tableView.endUpdates()
        }
    }
    
}

extension AddTasksViewController: AddTasksViewProtocol {
    
    func errorEmpty() {
        HUD.flash(.labeledError(title: "Add Tasks", subtitle: "Add one or more tasks"), delay: 2.0)
    }
    func errorSavingTasks(_ error: Error) {
        HUD.flash(.labeledError(title: "Add Tasks", subtitle: "Fail to save..."), delay: 2.0)
    }
    
    func startLoading() {
        HUD.show(.progress)
    }
    
    func finishLoading() {
        //HUD.hide()
    }
        
    func didSaveTasks() {
        HUD.flash(.success, delay: 2.0) { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.didSaveTasks(strongSelf)
        }
    }
    
    
}
