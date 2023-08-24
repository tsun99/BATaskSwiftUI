//
//  PostsView.swift
//  BATaskSwiftUI
//
//  Created by Tomas Sungaila on 8/24/23.
//

import SwiftUI

struct PostsView: View {
    
    @StateObject var viewModel = PostsViewModel()
    
    @State var hasLoaded = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.posts) { post in
                        
                        NavigationLink {
                            
                            PostDetailView(post: post)
                                
                        } label: {
                            if let user = viewModel.users.first(where: { $0.id == post.userId }) {
                                
                                SinglePostView(post: post, user: user)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                withAnimation {
                                    viewModel.deletePost(post: post)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .refreshable {
                    await viewModel.fetchData()
                }
                
            }
            .navigationTitle("Posts")
            .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
                Button("Retry") {
                    Task {
                        await viewModel.fetchData()
                    }
                }
                Button("Cancel") {
                    viewModel.hasError = false
                }
            }
        }
        .onAppear {
            if !hasLoaded {
                Task {
                    await viewModel.prepareData()
                }
                hasLoaded = true
            }
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
