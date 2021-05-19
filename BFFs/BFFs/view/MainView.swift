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
                if (viewModel.showList) {
                    Text("My BFFs").font(.title)
                }
                else {
                    Button(action: {self.viewModel.load()}) {
                        ButtonCircleView(icon: "arrow.clockwise", color: .primary, isLarge: false)
                    }
                }
                Spacer()
                ToggleView(value: self.$viewModel.showList, left: "magnifyingglass", right: "heart")
            }
            .padding()
            
            
            if (viewModel.showList) {
                UserListView(users: self.viewModel.users)
            }
            else {
                Spacer()
                
                UserGalleryView(users: self.viewModel.users)
                
                Spacer()
                
                // controls
                HStack {
                    Spacer()
                    Group {
                        Button(action: {self.viewModel.popCurrentUser()}) {
                            ButtonCircleView(icon: "xmark", color: .primary, isLarge: false)
                        }
                        Button(action: {self.viewModel.addToFavourites()}) {
                            ButtonCircleView(icon: "heart.fill", color: .accentColor, isLarge: true)
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                
                Spacer()
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .overlay(LoadingIndicator().foregroundColor(.primary).opacity(self.viewModel.isLoading ? 1.0 : 0.0))
        .onAppear{
            self.viewModel.load()
        }
    }
}
