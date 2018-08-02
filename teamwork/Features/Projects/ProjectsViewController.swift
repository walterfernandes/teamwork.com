
import UIKit
import PKHUD

class ProjectsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var refreshController: UIRefreshControl?
    
    let presenter = ProjectPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshController = UIRefreshControl(withMessage: "Loading projects ...",
                                                 target: self,
                                                 action: #selector(loadProjectList))
        tableView.refreshControl = refreshController
        self.refreshController = refreshController
        
        presenter.view = self
        loadProjectList()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tasklistViewController = segue.destination as? TasklistViewController {
            let indexPath = tableView.indexPathForSelectedRow!
            tasklistViewController.projectId = presenter.projectList[indexPath.row].id
        }
    }
    
    @objc func loadProjectList() {
        presenter.loadProjectList()
    }
}

extension ProjectsViewController: ProjectsViewProtocol {
    
    func error(_ error: Error) {
        HUD.flash(.labeledError(title: "Projects", subtitle: "Fail to load..."), delay: 2.0)
    }
    
    func startLoading() {
        refreshController?.beginRefreshing()
    }
    
    func finishLoading() {
        refreshController?.endRefreshing()
    }
    
    @objc func didLoadProjectList() {
        tableView.reloadData()
    }
    
}

extension ProjectsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.projectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        
        cell.project = presenter.projectList[indexPath.row]
        
        return cell
    }
    
}
