
import Foundation

protocol AddTasksViewProtocol {
    
    func errorEmpty()
    func errorSavingTasks(_ error:Error)
    func startLoading()
    func finishLoading()
    func didSaveTasks()

}

class AddTasksPresenter {
    
    private var taskAPI = TaskAPI()
    var view: AddTasksViewProtocol?
    
    init(_ api: TaskAPI? = nil) {
        if let taskAPI = api {
            self.taskAPI = taskAPI
        }
    }
    
    func saveTasks(_ tasks: [String], tasklistId: String, projectId: String) {
        
        guard tasks.count > 0 else {
            view?.errorEmpty()
            return
        }
        
        view?.startLoading()
       
        let tasks = MultTaskPost(content: tasks.joined(separator: "\n"),
                                 tasklistId: tasklistId,
                                 projectId: projectId)
        
        taskAPI.postMultipleTasks(tasks) { [weak self] response in
            switch response {
            case .success:
                self?.view?.didSaveTasks()
            case .error(let error):
                self?.view?.errorSavingTasks(error)
            }
            self?.view?.finishLoading()
        }
    }
}
