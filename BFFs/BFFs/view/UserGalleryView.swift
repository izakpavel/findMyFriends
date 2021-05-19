//
//  UserGalleryView.swift
//  BFFs
//
//  Created by Pavel Zak on 19.05.2021.
//

import SwiftUI

struct UserGalleryView: View {
    var users: [User]
    
    private let baseOffset: CGFloat = 16
    
    func offsetForItem(at index: Int) -> CGSize {
        let baseOffset: CGFloat = 16
        let multiplier = CGFloat(self.users.count - index)
        return CGSize(width: -baseOffset*multiplier, height: -baseOffset*multiplier)
    }
    
    func scaleOfItem(at index: Int) -> CGFloat {
        guard self.users.count>1 else { return 1.0 }
        
        let multiplier = CGFloat(self.users.count - index)
        let step = 1.0/CGFloat(users.count)
        return (1.0 - multiplier*step)*0.5 + 0.5
    }
    
    func counterOffset() -> CGSize {
        let multiplier = CGFloat(self.users.count-1)*0.5
        return CGSize(width: baseOffset*multiplier, height: baseOffset*multiplier)
    }
    
    var body: some View {
        
        ZStack {
            ForEach(Array(zip(users.indices, users)), id: \.0) { index, user in
                RoundedRectangle(cornerRadius: 16)
                    .scaleEffect(self.scaleOfItem(at: index))
                    .offset(self.offsetForItem(at: index))
            }
        }
        .offset(self.counterOffset())
        .frame(width: 300, height: 300)
    }
}

