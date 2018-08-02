
import Foundation
 
struct Project: Codable {
	
	var starred: Bool
	var name: String
	var description: String
	var status: String
	var logo: URL?
	var id: String
    var createdOn: Date
    var startDate: Date?
	var endDate: Date?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Project.CodingKeys.self)
        self.starred = try container.decode(Bool.self, forKey: .starred)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.status = try container.decode(String.self, forKey: .status)
        self.logo = try container.decode(URL.self, forKey: .logo)
        self.id = try container.decode(String.self, forKey: .id)
        self.createdOn = try container.decode(Date.self, forKey: .createdOn)
        if let startDateString = try container.decodeIfPresent(String.self, forKey: .startDate){
            self.startDate = DateFormatter.yyyyMMdd.date(from: startDateString)
        }
        if let endDateString = try container.decodeIfPresent(String.self, forKey: .endDate) {
            self.endDate = DateFormatter.yyyyMMdd.date(from: endDateString)
        }
    }
}
