//
//  APIClient.swift
//
//  Created by rendi on 22.04.2024.
//

import Foundation

protocol APIEndpoint {
    associatedtype ResponseType: Decodable // Define associated type for response
    
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

class APIClient {
    private static let API_URL = "https://api.openweathermap.org/data/2.5"
    private static let API_KEY = "fb9b56284059309e85bf44dd60f9cd57"
    
    func request<T: APIEndpoint>(_ endpoint: T, completion: @escaping (Result<T.ResponseType, Error>) -> Void) {
        // Construct URL
        let constructedURL = "\(APIClient.API_URL)\(endpoint.path)&appid=\(APIClient.API_KEY)"
        guard let url = URL(string: constructedURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body
        
        // Perform network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Server Error", code: 0, userInfo: nil)))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.ResponseType.self, from: responseData)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
