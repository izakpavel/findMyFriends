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
        List() {
            ForEach (self.users) { user in
                Text(user.email ?? "")
            }
        }
    }
}
