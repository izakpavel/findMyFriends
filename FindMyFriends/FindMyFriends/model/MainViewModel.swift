//
//  MainViewModel.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 23.04.2021.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var users: [User] = []
    @Published var requestUserCount: Int = 5
    @Published var showList: Bool = false
    
    private var cancellable: AnyCancellable?
    
    func load() {
        let session = ApiSession()
        let provider = RandomUsersProvider(apiSession: session)
        
        self.isLoading = true
        
        self.cancellable = provider.getUsers(count: self.requestUserCount)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { items in
                self.users = items
                self.isLoading = false
                self.objectWillChange.send()
        })
    }
}
