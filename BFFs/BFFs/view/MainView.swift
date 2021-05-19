//
//  MainView.swift
//  BFFs
//
//  Created by Pavel Zak on 19.05.2021.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        VStack {
            // header
            HStack {
                Button(action: {self.viewModel.load()}) {
                    ButtonCircleView(icon: "arrow.clockwise", color: .primary, isLarge: false)
                }
                Spacer()
                ToggleView(left: "magnifyingglass", right: "heart")
            }
            .padding()
            
            Spacer()
            
            UserGalleryView(users: self.viewModel.users)
            
            Spacer()
            
            // controls
            HStack {
                Spacer()
                Button(action: {self.viewModel.popCurrentUser()}) {
                    ButtonCircleView(icon: "xmark", color: .primary, isLarge: false)
                }
                Spacer()
                Button(action: {self.viewModel.addToFavourites()}) {
                    ButtonCircleView(icon: "heart.fill", color: .accentColor, isLarge: true)
                }
                Spacer()
            }
            
            Spacer()
        }
        .background(Color.background)
        .overlay(LoadingIndicator().foregroundColor(.primary).opacity(self.viewModel.isLoading ? 1.0 : 0.0))
        .onAppear{
            self.viewModel.load()
        }
    }
}
