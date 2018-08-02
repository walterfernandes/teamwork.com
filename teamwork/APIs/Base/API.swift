
import Foundation

enum APIError: Error {
    case invalidURL
    case parameterEncodingFailed
    case responseSerializationFailed
    case responseError(code: Int)
    case emptyData
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Response<T> {
    case success(T)
    case error(Error)
}

struct Empty: Decodable {
    
}

class API<S: Service> {
    
    var credential: URLCredential?
    
    init() {
        credential = URLCredential(user: "twp_k9ejP88LcuojHjmFkUFuYIUNYalg", password: "xxx", persistence: .forSession)
    }
    
    func request<T: Decodable> (_ service: S, responseHandler: ((Response<T>) -> Void)?) {
    
        guard let url = URL(string: service.baseURL + service.path ) else {
            responseHandler?(.error(APIError.invalidURL))
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = service.method.rawValue
        
        service.headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        do {
            urlRequest.httpBody = try service.requestBody()
        } catch {
            responseHandler?(.error(APIError.responseSerializationFailed))
            print("Error: cannot create body")
            return
        }

        let configuration = URLSessionConfiguration.default

        if let credential = self.credential {
            let base64EncodedCredential = "\(credential.user!):\(credential.password!)".data(using: .utf8)!.base64EncodedString()
            configuration.httpAdditionalHeaders = ["Authorization" : "Basic \(base64EncodedCredential)"]
        }

        let session = URLSession.init(configuration: configuration, delegate: nil, delegateQueue: nil)
        
        print("urlRequest: \(urlRequest.debugDescription)")
        print("headers: \(urlRequest.allHTTPHeaderFields.debugDescription)")
        print("method: \(urlRequest.httpMethod ?? "")")
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    responseHandler?(.error(error!))
                }
                print(error!)
                return
            }

            guard let responseData = data else {
                DispatchQueue.main.async {
                    responseHandler?(.error(APIError.emptyData))
                }
                return
            }

            print("data: \(String(data: responseData, encoding: .utf8)!)")
            
            let successCodes = 200..<300
            if let httpResponse = response as? HTTPURLResponse {
                guard successCodes.contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        responseHandler?(.error(APIError.responseError(code: httpResponse.statusCode)))
                    }
                    return
                }
            }
            
            do {
                
                let decodedResponse = try service.decodeResponseData(type: T.self, data: responseData)
                
                DispatchQueue.main.async {
                    responseHandler?(.success(decodedResponse))
                }
                
            } catch (let error)  {
                DispatchQueue.main.async {
                    responseHandler?(.error(error))
                }
                print("error parsing response")
                return
            }
        }
        
        task.resume()
    }
    
}


