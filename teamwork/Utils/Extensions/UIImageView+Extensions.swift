
import UIKit

extension UIImageView {
    
    public func image(from url: URL) {
        image = nil
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.image = UIImage(data: data!)
            }
            
        }).resume()
    }
    
}
