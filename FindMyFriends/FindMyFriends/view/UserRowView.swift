//
//  UserRowView.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 27.04.2021.
//

import Foundation
import UIKit
import Nuke

class UserRowView: UIStackView {
    weak var imageView: UIImageView?
    weak var titleLabel: UILabel?
    weak var detailLabel: UILabel?
    weak var vStack: UIStackView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    func commonInit() {
        
        self.distribution = .fill
        self.spacing = Appearance.padding
        self.alignment = .center
        self.axis = .horizontal
        
        let titleLabel = UILabel()
        titleLabel.textColor = Appearance.primaryTextColor
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0
        self.titleLabel = titleLabel
        
        let detailLabel = UILabel()
        detailLabel.textColor = Appearance.secondaryTextColor
        detailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        detailLabel.numberOfLines = 0
        self.detailLabel = detailLabel
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        vStack.distribution = .equalSpacing
        vStack.spacing = 2
        vStack.alignment = .leading
        vStack.axis = .vertical
        self.vStack = vStack
        
        let imageView = UIImageView()
        self.imageView = imageView
        
        [imageView, vStack].forEach {
            self.addArrangedSubview($0)
        }
    }
    
    func setUser(_ user: User) {
        self.titleLabel?.text = user.name?.fullName
        self.detailLabel?.text = user.login?.username
        
        if let url = URL(string: user.picture?.large ?? ""), let imageView = self.imageView {
            let options = ImageLoadingOptions(
              placeholder: UIImage(named: "placeholder"),
              transition: .fadeIn(duration: 0.3)
            )
            
            let imageRequest = ImageRequest(url: url, processors: [
                ImageProcessors.Resize(size: CGSize(width: 64, height: 64)),
                ImageProcessors.Circle()
            ])
            Nuke.loadImage(with: imageRequest, options: options, into: imageView)
        }
    }
}
