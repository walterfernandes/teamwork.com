
import Foundation

extension Dictionary where Key: StringProtocol  {

    var queryString: String {
        return map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
    }
    
}
