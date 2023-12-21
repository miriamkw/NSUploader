//
//  APIClient.swift
//  NSUploader
//
//  Created by Miriam K. Wolff on 18/10/2023.
//

import Foundation
import CommonCrypto

class APIClient {
    static let shared = APIClient()
    private init() {}
    
    private let url = Config.url
    private let apiSecret = Config.apiSecret

    // TODO: Idea to fix this is to revisit the Udemy Swift course and use that code :-)
    
    func sendDataToAPI(endpoint: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: url + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        print("URL: ", url)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set request headers using the requestHeaders function
        let headers = requestHeaders(apiSecret: apiSecret)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        
        // TODO: Get API key from a .gitignore file
        // request.setValue("Bearer wD6KB2HvJ5ZL3FZphKjbPLdHb5C1zEix", forHTTPHeaderField: "Authorization")
        // request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            print(jsonData)
            
            request.httpBody = jsonData
            
            // Print the JSON string representation for debugging
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON Data: \(jsonString)")
            }

            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                        if let error = error {
                            completion(.failure(error))
                            print("ERROR!")
                            print("Request Error: \(error.localizedDescription)")
                        } else {
                            if let httpResponse = response as? HTTPURLResponse {
                                print("HTTP RESPONSE!")
                                
                                if (200...299).contains(httpResponse.statusCode) {
                                    completion(.success(()))
                                    print("Request Successful")
                                } else {
                                    let responseError = APIError.invalidResponse
                                    completion(.failure(responseError))
                                    print("Invalid Response: \(httpResponse.statusCode)")
                                }
                            } else {
                                let responseError = APIError.invalidResponse
                                completion(.failure(responseError))
                                print("Invalid Response: Unknown HTTP Response")
                            }
                        }
                    }
            task.resume()
        } catch {
            completion(.failure(error))
            print("JSON Serialization Error: \(error.localizedDescription)")
        }
    }
    
    func requestHeaders(apiSecret: String?) -> [String: String] {
        var headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let apiSecret = apiSecret {
            let hashedSecret = sha1Hash(apiSecret)
            headers["api-secret"] = hashedSecret
        }
        
        return headers
    }

    func sha1Hash(_ input: String) -> String {
        if let data = input.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            data.withUnsafeBytes {
                _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
            }
            return digest.map { String(format: "%02hhx", $0) }.joined()
        }
        return ""
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
}

