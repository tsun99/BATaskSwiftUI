//
//  SinglePostViewModel.swift
//  BATaskSwiftUI
//
//  Created by Tomas Sungaila on 8/24/23.
//

import Foundation

class PostDetailViewModel: ObservableObject {
    
    @Published var user: User?
    
    @Published var error: NetworkingManager.NetworkingError?
    @Published var hasError = false
    
    @MainActor
    func fetchUser(for id: Int) async {
        
        let apiURL = "https://jsonplaceholder.typicode.com/users/\(id)"
        
        do {
            self.user = try await NetworkingManager.shared.request(apiURL, type: User.self)
            
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError { self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
}
