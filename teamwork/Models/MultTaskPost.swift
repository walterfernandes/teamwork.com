
import Foundation

struct MultTaskPost: Codable {

    var content: String
    var tasklistId: String
    var projectId: String?
    
    enum CodingKeys: String, CodingKey {
        case content
        case tasklistId = "tasklistId"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encode(tasklistId, forKey: .tasklistId)
    }
}
