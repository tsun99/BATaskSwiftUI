//
//  SinglePostView.swift
//  BATaskSwiftUI
//
//  Created by Tomas Sungaila on 8/24/23.
//

import SwiftUI

struct SinglePostView: View {
    var post: Post
    var user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 8) {
                Image(systemName: "person.circle")
                    .font(.system(size: 40))
                
                Text("\(user.username)")
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .leading) {
                Text("\(post.title)")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.bottom, 2)
                
                Text("\(post.body)")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
        }
        
    }
}

struct SinglePostView_Previews: PreviewProvider {
    static var previews: some View {
        SinglePostView(post: Post(id: 1, userId: 1, title: "title", body: "body"), user: User(id: 1, name: "name", username: "username"))
    }
}
