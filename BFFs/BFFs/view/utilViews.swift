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
            .font(isLarge ? .largeTitle : .title2)
            .foregroundColor(color)
            .padding(isLarge ? 32 : 16)
            .background(Color.backgroundSecondary)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}
