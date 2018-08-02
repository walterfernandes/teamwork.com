
import Foundation

struct Task: Codable {

    struct Tag: Codable {
        var id: Int
        var name: String
        var color: String
    }
    
    var id: Int
    var content: String?
    var responsiblePartyNames: String?
    var completed: Bool
    var createdOn: Date
    var tags: [Tag]?
}
