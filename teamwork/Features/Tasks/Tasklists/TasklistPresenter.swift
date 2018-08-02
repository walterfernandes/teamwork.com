
import Foundation

protocol TasklistViewProtocol: class {
    func errorLoadingTasks(_ error:Error)
    func startLoading()
    func finishLoading()
    func didLoadTasklist()
}

class TasklistPresenter {

    private var taskAPI = TaskAPI()
    weak var view: TasklistViewProtocol?
    
    private var asyncError: Error?
    var tasklists = [Tasklist]()
    var tasksByList = [String: [Task]]()
    
    init(_ api: TaskAPI? = nil) {
        if let taskAPI = api {
            self.taskAPI = taskAPI
        }
    }
    
     func loadTasksByList(byProject projectId: String) {
        view?.startLoading()
        DispatchQueue.global().async { [weak self] in
            
            self?.loadTasklist(byProject: projectId, waitGroup: DispatchGroup())
            
            guard self?.asyncError == nil else {
                DispatchQueue.main.async {
                    self?.finishLoad()
                }
                return
            }

            self?.tasklists.forEach { self?.loadTasks(byTasklist: $0.id, waitGroup: DispatchGroup()) }
            
            DispatchQueue.main.async {
                self?.finishLoad()
            }
        }

    }

    private func finishLoad() {
        view?.finishLoading()
        
        if let error = asyncError {
            view?.errorLoadingTasks(error)
        } else {
            view?.didLoadTasklist()
        }
    }
    
    private func loadTasklist(byProject projectId: String, waitGroup group:DispatchGroup) {
        group.enter()
        taskAPI.getTasklists(byProject: projectId) {[weak self] response in
            switch response {
            case .success(let tasklists):
                self?.tasklists = tasklists
            case .error(let responseError):
                self?.view?.errorLoadingTasks((self?.asyncError)!)
                self?.view?.finishLoading()
                self?.asyncError = responseError
            }
            group.leave()
        }
        group.wait()
    }
    
    private func loadTasks(byTasklist tasklistId: String, waitGroup group:DispatchGroup) {
        group.enter()
        taskAPI.getTasks(byTasklist: tasklistId) { [weak self] response in
            switch response {
            case .success(let tasks):
                self?.tasksByList[tasklistId] = tasks
            case .error(let responseError):
                self?.asyncError = responseError
            }
            group.leave()
        }
        group.wait()
    }
}
