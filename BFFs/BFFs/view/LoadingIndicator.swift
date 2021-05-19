//
//  LoadingIndicator.swift
//  BFFs
//
//  Created by Pavel Zak on 19.05.2021.
//

import SwiftUI

struct LoadingIndicator: View {
    private let animationDuration: Double = 1.3
    let count = 7
    let size: CGFloat = 12
    @State var value: CGFloat = 0
    
    func startAnimation() {
        withAnimation(.easeInOut(duration: animationDuration).repeatForever(autoreverses: true)) {
            self.value = 1
        }
    }
    
    var body: some View {
        ZStack {
            ForEach(0 ..< self.count) { index in
                Circle()
                    .offset(CGSize(width: value*self.size, height: 0.0))
                    .rotationEffect(Angle(degrees: 360/Double(self.count)*Double(index)))
                    .opacity(1.0/Double(count))
            }
        }
        .rotationEffect(Angle(degrees: 360*Double(self.value)))
        .frame(width: self.size, height: self.size)
        .onAppear {
            self.startAnimation()
        }
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
    }
}
