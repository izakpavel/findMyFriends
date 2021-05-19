//
//  MainView.swift
//  BFFs
//
//  Created by Pavel Zak on 19.05.2021.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            // header
            HStack {
                Spacer()
                ToggleView(left: "magnifyingglass", right: "heart")
            }
            
        }
        .background(Color.background)
        .overlay(LoadingIndicator().foregroundColor(.primary))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
