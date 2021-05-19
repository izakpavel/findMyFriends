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
                ToggleView(left: "♀️", right: "♂️")
                Spacer()
                ToggleView(left: "magnifyingglass", right: "heart")
            }
            
        }
        .background(Color.background)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
