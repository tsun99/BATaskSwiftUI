//
//  PostDetailView.swift
//  BATaskSwiftUI
//
//  Created by Tomas Sungaila on 8/24/23.
//

import SwiftUI

struct PostDetailView: View {
    
    var post: Post
    
    @StateObject var viewModel = PostDetailViewModel()
    @State var hasLoaded = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                HStack(spacing: 8) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 44))
                    
                    VStack(alignment: .leading) {
                        Text("\(viewModel.user?.username ?? "N/A")")
                            .font(.headline)
                        Text("\(viewModel.user?.name ?? "N/A")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(8)
                
                VStack {
                    
                    VStack(alignment: .center) {
                        Text("\(post.title)")
                            .font(.title2)
                            .bold()
                            .padding()
                    }
                    VStack(alignment: .leading) {
                        Text("\(post.body)")
                    }
                    .padding()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("detail-background"), in: RoundedRectangle(cornerRadius: 20))
                
                Spacer()
            }
        }
        .padding(.vertical)
        .task {
            if !hasLoaded {
                await viewModel.fetchUser(for: post.userId)
                hasLoaded = true
            }
        }
        .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
            Button("Retry") {
                Task {
                    await viewModel.fetchUser(for: post.userId)
                }
            }
            Button("Cancel") {
                viewModel.hasError = false
            }
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        PostDetailView(post: Post(id: 1, userId: 1, title: "", body: ""))
    }
}
