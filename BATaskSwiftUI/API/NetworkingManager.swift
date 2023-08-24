//
//  NetworkingManager.swift
//  BATaskSwiftUI
//
//  Created by Tomas Sungaila on 8/24/23.
//

import Foundation

class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    func request<T: Codable>(_ apiURL: String, type: T.Type) async throws -> T {
        
        guard let url = URL(string: apiURL) else {
            throw NetworkingError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            throw NetworkingError.invalidData
        }
        
    }
}

extension NetworkingManager {
    enum NetworkingError: LocalizedError {
        case invalidUrl
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case custom(error: Error)
    }
}

extension NetworkingManager.NetworkingError {
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "URL is not valid!"
        case .invalidStatusCode:
            return "Trouble getting an HTTP response"
        case .invalidData:
            return "Failed to Decode data"
        case .custom(let error):
            return "Error encountered - \(error.localizedDescription)"
        }
    }
}
