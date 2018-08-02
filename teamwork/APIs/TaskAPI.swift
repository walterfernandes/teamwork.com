
import Foundation

enum TaskService {
    case getTasklists(projectId: String)
    case getTasks(tasklistId: String)
    case postMultipleTasks(multTaskPost: MultTaskPost)
}

extension TaskService: Service {
    
    var path: String {
        switch self {
        case .getTasklists(let projectId):
            return "/projects/\(projectId)/tasklists.json"
        case .getTasks(let tasklistId):
            return "/tasklists/\(tasklistId)/tasks.json"
        case .postMultipleTasks(let multTaskPost):
            return "/projects/\(multTaskPost.projectId!)/tasks/quickadd.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postMultipleTasks:
            return .post
        default:
            return .get
        }
    }
    
    var rootElementName: String? {
        switch self {
        case .getTasks:
            return "todoItems"
        case .getTasklists:
            return "tasklists"
        default:
            return nil
        }
    }

    func requestBody() throws -> Data? {
        switch self {
        case .postMultipleTasks(let multTaskPost):
            return try JSONEncoder().encode(multTaskPost)
        default:
            return nil
        }
    }
    
}

class TaskAPI {
    
    let api = API<TaskService>()
    
    func getTasklists(byProject projectId: String, responseHandler: @escaping (Response<[Tasklist]>) -> Void) {
        api.request(.getTasklists(projectId: projectId), responseHandler: responseHandler)
    }

    func getTasks(byTasklist tasklistId: String, responseHandler: @escaping (Response<[Task]>) -> Void) {
        api.request(.getTasks(tasklistId: tasklistId), responseHandler: responseHandler)
    }
    
    func postMultipleTasks(_ multiTaskPost:MultTaskPost, responseHandler: @escaping (Response<Empty>) -> Void) {
        api.request(.postMultipleTasks(multTaskPost: multiTaskPost), responseHandler: responseHandler)
    }
}
