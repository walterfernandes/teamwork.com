
import Foundation

enum ProjectService {
    case getProjectList
}

extension ProjectService: Service {
    
    var path: String {
        switch self {
        case .getProjectList:
            return "/projects.json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var rootElementName: String? {
        return "projects"
    }
        
    func requestBody() throws -> Data? {
        return nil
    }
    
}

class ProjectAPI {
    
    var api = API<ProjectService>()
    
    init(_ mockedAPI: API<ProjectService>? = nil) {
        if mockedAPI != nil {
            self.api = mockedAPI!
        }
    }
    
    func getProjectList(_ responseHandler: @escaping (Response<[Project]>) -> Void) {
         api.request(.getProjectList, responseHandler: responseHandler)
    }
    
}
