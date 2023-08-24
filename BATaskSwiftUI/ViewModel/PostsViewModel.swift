//
//  PostsViewModel.swift
//  BATaskSwiftUI
//
//  Created by Tomas Sungaila on 8/24/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class PostsViewModel: ObservableObject {
    
    @Published var posts = [Post]()
    @Published var users = [User]()
    
    @Published var error: NetworkingManager.NetworkingError?
    @Published var hasError = false
    
    var fetchedPosts: [Post] = []
    var fetchedUsers: [User] = []
    
    @MainActor
    func getData(collection: String) async {
        
        let currentCollection = Firestore.firestore().collection(collection)
        
        
        do {
            let snapshot = try await currentCollection.getDocuments()
            
            if collection == collectionType.posts.rawValue {
                self.posts = try snapshot.documents.map({
                    try $0.data(as: Post.self)
                })
            }
            if collection == collectionType.users.rawValue {
                self.users = try snapshot.documents.map({
                    try $0.data(as: User.self)
                })
            }
            
        } catch {
            print("Error encountered while getting getting data back from firestore")
            return
        }
        
        
    }
    
    func prepareData() async {
        
        await getData(collection: collectionType.posts.rawValue)
        await getData(collection: collectionType.users.rawValue)
    }
    
    @MainActor
    func fetchData() async {
        let postsApiUrl = "https://jsonplaceholder.typicode.com/posts"
        let usersApiUrl = "https://jsonplaceholder.typicode.com/users"
        
        do {
            self.fetchedPosts = try await NetworkingManager.shared.request(postsApiUrl, type: [Post].self)
            self.fetchedUsers = try await NetworkingManager.shared.request(usersApiUrl, type: [User].self)
            
        } catch {
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError { self.error = networkingError
            } else {
                self.error = .custom(error: error)
            }
        }
        await refreshDatabase(collection: collectionType.posts.rawValue)
        await refreshDatabase(collection: collectionType.users.rawValue)
    }
    
    func refreshDatabase(collection: String) async {
        let db = Firestore.firestore()
        let batch = db.batch()
        
        do {
            
            let postsSnapshot = try await db.collection(collectionType.posts.rawValue).getDocuments()
            let usersSnapshot = try await db.collection(collectionType.users.rawValue).getDocuments()
            
//             deleting all documents in collection, before populating with newly fetched ones
            for document in postsSnapshot.documents {
                batch.deleteDocument(document.reference)
            }
            
            for document in usersSnapshot.documents {
                batch.deleteDocument(document.reference)
            }
            
//             Encoding data and adding it to the database
            for post in fetchedPosts {
                let docRef = db.collection(collectionType.posts.rawValue).document()
                guard let encodedPost = try? Firestore.Encoder().encode(post) else {
                    return
                }
                batch.setData(encodedPost, forDocument: docRef)
            }
            for user in fetchedUsers {
                let docRef = db.collection(collectionType.users.rawValue).document()
                guard let encodedUser = try? Firestore.Encoder().encode(user) else {
                    return
                }
                batch.setData(encodedUser, forDocument: docRef)
            }

            try await batch.commit()
        } catch {
            print("Error encountered while refreshing databases.")
            return
        }
        
        await self.getData(collection: collectionType.posts.rawValue)
        await self.getData(collection: collectionType.users.rawValue)
    }
    
    func deletePost(post: Post){
        let db = Firestore.firestore()
        
        db.collection("posts").whereField("id", isEqualTo: post.id).getDocuments { snapshot, error in
            
            if error == nil {
                DispatchQueue.main.async {
                    snapshot!.documents.first!.reference.delete()
                    
                    self.posts.removeAll { postToDelete in
                        return post.id == postToDelete.id
                    }
                }
            }
        }
    }
}

extension PostsViewModel {
    
    private enum collectionType: String {
        case posts = "posts"
        case users = "users"
    }
    private enum variableType {
        
    }
}
