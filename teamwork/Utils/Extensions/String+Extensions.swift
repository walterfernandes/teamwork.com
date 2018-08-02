
import Foundation

extension String {

    func camelCased(separatedBy separator:String) -> String {
        return components(separatedBy: separator).enumerated().map {
            $0.offset == 0 ? $0.element : $0.element.capitalized
        }.joined()
    }

}
