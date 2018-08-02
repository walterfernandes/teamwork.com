
import Foundation

struct ResponseDecoder<T: Decodable>: Decodable {
    
    var status: String
    var data: T
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseDecoderCodingKey.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.data = try container.decode(T.self, forKey: .data)
    }
    
}

extension ResponseDecoder {
    
    static func decode(_ data: Data, rootElement rootElementOrNil: String? = nil) throws -> ResponseDecoder {
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .custom({ keys in
            let lastKey = keys.last!.stringValue.camelCased(separatedBy: "-")
            
            if let rootElement = rootElementOrNil,
                rootElement == lastKey {
                return ResponseDecoderCodingKey.data
            }
            
            return ResponseDecoderCodingKey(stringValue: String(lastKey))!
        })
        
        return try decoder.decode(ResponseDecoder.self, from: data)
    }
}

fileprivate struct ResponseDecoderCodingKey: CodingKey {
        
    var intValue: Int?
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
    
    static let status = ResponseDecoderCodingKey(stringValue: "STATUS")!
    static let data = ResponseDecoderCodingKey(stringValue: "data")!
    
}

