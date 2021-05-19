//
//  ToggleView.swift
//  BFFs
//
//  Created by Pavel Zak on 19.05.2021.
//

import SwiftUI

struct IconView: View {
    let name: String
    
    var body: some View {
        if (name.count == 1) {
            Text(name)
        }
        else {
            Image(systemName: name)
        }
    }
}

struct ToggleViewHighlightShape: Shape {
    
    var value: CGFloat
    
    var animatableData: CGFloat {
        set { self.value = newValue }
        get { return self.value }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let width = rect.width
            let height = rect.height
            
            let shapeWidth = width/2
            let factor = cos(value*CGFloat.pi*2)*0.25 + 0.75
            let shapeHeight = height*factor
            let xOffset = shapeWidth*value
            
            path.addRoundedRect(in: CGRect(origin: CGPoint(x: xOffset, y: (height-shapeHeight)/2), size: CGSize(width: shapeWidth, height: shapeHeight)), cornerSize: CGSize(width: width/2, height: height/2))
        }
    }
}

struct ToggleView: View {
    
    let left: String
    let right: String
    @State var value: Bool = true
    
    var backgroundValue: CGFloat {
        return value ? 1.0 : 0.0
    }
    
    var body: some View {
        
        let backgroundView = GeometryReader { geometry in
            Color.backgroundSecondary
                .clipShape(RoundedRectangle(cornerRadius: geometry.size.height/2))
        }
        
        return HStack (alignment: .center, spacing: 0) {
            Group {
                IconView(name: left)
                    .foregroundColor(self.value ? .secondary : .primary)
                    .scaleEffect(self.value ? 0.8 : 1.0)
                IconView(name: right)
                    .foregroundColor(self.value ? .primary : .secondary)
                    .scaleEffect(self.value ? 1.0 : 0.8)
            }
            .font(.title)
            .padding(8)
        }
        .background (
            ToggleViewHighlightShape(value: self.backgroundValue)
                .fill(Color.accentColor)
        )
        .padding(8)
        .background(backgroundView)
        .onTapGesture {
            withAnimation() {
                self.value.toggle()
            }
        }
    }
}
