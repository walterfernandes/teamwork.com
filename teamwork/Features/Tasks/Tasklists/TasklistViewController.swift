
import UIKit
import PKHUD

class TasklistViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let presenter = TasklistPresenter()
    private weak var refreshController: UIRefreshControl?
    
    var projectId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let refreshController = UIRefreshControl(withMessage: "Loading tasks ...",
                                                 target: self,
                                                 action: #selector(loadTasks))
        tableView.refreshControl = refreshController
        self.refreshController = refreshController
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        tableView.estimatedSectionHeaderHeight = 30;
        tableView.register(TasklistHeaderView.self, forHeaderFooterViewReuseIdentifier: TasklistHeaderView.reuseIdentifier!)
        
        presenter.view = self
        loadTasks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addTasksViewController = segue.destination as? AddTasksViewController,
            let senderButton = sender as? UIButton {
            
            addTasksViewController.delegate = self
            addTasksViewController.tasklist = presenter.tasklists[senderButton.tag]
        }
    }
    
    @objc func loadTasks() {
        presenter.loadTasksByList(byProject: projectId)
    }
    
    @objc func segueToAddTask(_ sender: UIButton) {
        performSegue(withIdentifier: "AddTasksSegue", sender: sender)
    }
}

extension TasklistViewController: TasklistViewProtocol {
   
    func errorLoadingTasks(_ error: Error) {
        HUD.show(.labeledError(title: "Tasklist", subtitle: "Fail to load..."))
    }
    
    func didLoadTasklist() {
        tableView.reloadData()
    }
    
    func startLoading() {
        refreshController?.beginRefreshing()
    }
    
    func finishLoading() {
        refreshController?.endRefreshing()
    }
    
}

extension TasklistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TasklistHeaderView.reuseIdentifier!) as! TasklistHeaderView
        
        headerView.titleLabel.text = presenter.tasklists[section].name
        headerView.addTasksButton.addTarget(self, action: #selector(segueToAddTask(_:)), for: .touchUpInside)
        headerView.addTasksButton.tag = section
        
        return headerView

    }
    
}

extension TasklistViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.tasklists.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tasklist = presenter.tasklists[section]
        return presenter.tasksByList[tasklist.id]?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tasklist = presenter.tasklists[indexPath.section]
        
        if let task = presenter.tasksByList[tasklist.id]?[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            cell.task = task
            
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
        }
        
    }
    
}

extension TasklistViewController: AddTasksViewControllerDelegate {
    
    func didSaveTasks(_ addTasksViewController: AddTasksViewController) {
        addTasksViewController.navigationController?.popViewController(animated: true)
        presenter.loadTasksByList(byProject: projectId)
    }

}
