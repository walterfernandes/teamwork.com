
import UIKit

class ProjectCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var staredButton: UIButton!
    
    var project: Project? {
        didSet {

            guard let project = self.project else {
                nameLabel.text = nil
                descriptionLabel.text = nil
                datesLabel.text = nil
                logoImageView.image = nil
                staredButton.isSelected = false
                return
            }

            nameLabel.text = project.name
            descriptionLabel.text = project.description
            staredButton.isSelected = project.starred
            
            if let logoUrl = project.logo {
                logoImageView.image(from: logoUrl)
            }
            
            if let startDate = project.startDate,
                let endDate = project.endDate {
                datesLabel.text = "\(DateFormatter.Short.string(from: startDate)) - \(DateFormatter.Short.string(from: endDate))"
            }
            
        }
    }
}
