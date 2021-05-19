//
//  utilViews.swift
//  BFFs
//
//  Created by Pavel Zak on 19.05.2021.
//

import SwiftUI

struct ButtonCircleView: View {
    let icon: String
    let color: Color
    let isLarge: Bool
    
    var body: some View {
        Image(systemName: icon)
            .font(isLarge ? .largeTitle : .title)
            .foregroundColor(color)
            .padding(isLarge ? 32 : 16)
            .background(Color.backgroundSecondary)
            .clipShape(Circle())
    }
}
