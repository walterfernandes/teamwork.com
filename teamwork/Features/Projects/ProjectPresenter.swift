
import Foundation

protocol ProjectsViewProtocol: class {
    func error(_ error:Error)
    func startLoading()
    func finishLoading()
    func didLoadProjectList()
}

class ProjectPresenter {
    
    private var projectAPI = ProjectAPI()
    weak var view: ProjectsViewProtocol?
    
    var projectList = [Project]()
    
    init(_ api: ProjectAPI? = nil) {
        if let projectAPI = api {
            self.projectAPI = projectAPI
        }
    }
    
    @objc func loadProjectList() {
        
        view?.startLoading()
        
        projectAPI.getProjectList { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            switch response {
            case .success(let projectList):
                strongSelf.projectList = projectList
                strongSelf.view?.didLoadProjectList()
            case .error(let error):
                strongSelf.view?.error(error)
            }
            
            strongSelf.view?.finishLoading()
        }
        
    }
    
}
