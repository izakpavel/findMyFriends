//
//  UserListView.swift
//  BFFs
//
//  Created by Pavel Zak on 19.05.2021.
//

import SwiftUI

struct UserListView: View {
    
    var users: [User]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack() {
                ForEach (self.users) { user in
                    HStack {
                        ImageView(url: URL(string: user.picture?.large ?? "")!)
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                        
                        Text(user.email ?? "")
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
}
