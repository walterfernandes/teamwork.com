
import Foundation

protocol Service {
    
    var baseURL: String { get }
    
    var path: String { get }
    
    var method: HTTPMethod { get }
    
    var headers: [String: String]? { get }
    
    var rootElementName: String? { get }
    
    func requestBody() throws -> Data?
    
    func decodeResponseData<T: Decodable>(type: T.Type, data: Data) throws -> T
    
}

extension Service {
    
    var baseURL: String {
        return "https://yat.teamwork.com"
    }
    
    var headers: [String: String]? {
        if method == .post {
            return ["Content-Type": "application/json"]
        }
        return nil
    }
    
    func decodeResponseData<T: Decodable>(type: T.Type, data: Data) throws -> T {
        guard Empty.self != T.self else {
            return Empty() as! T
        }
        
        let decodedResponse = try ResponseDecoder<T>.decode(data, rootElement: rootElementName)
        return decodedResponse.data
    }
}
