//
//  UserAnnotationView.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 27.04.2021.
//

import Foundation
import Mapbox
import Nuke

class UserAnnotationView: MGLAnnotationView {
    weak var titleLabel: UILabel?
    weak var imageView: UIImageView?
    
    var circleSize: CGFloat {
        return 64
    }
    
    var preferredSize: CGSize {
        let total = self.circleSize + Appearance.padding*3
        return CGSize(width: total, height: total)
    }
    
    override init(annotation: MGLAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        titleLabel.backgroundColor = Appearance.backgroundColor
        titleLabel.textColor = Appearance.primaryTextColor
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = Appearance.padding/2
        titleLabel.layer.masksToBounds = true
        self.titleLabel = titleLabel
        
        let imageView = UIImageView()
        self.imageView = imageView
        
        [titleLabel, imageView].forEach{
            self.addSubview($0)
        }
    }
    
    func setUserAnnotation(_ annotation: UserAnnotation) {
        self.titleLabel?.text = annotation.user.name?.first
        
        if let url = URL(string: annotation.user.picture?.large ?? ""), let imageView = self.imageView {
            let options = ImageLoadingOptions(
              placeholder: UIImage(named: "placeholder"),
              transition: .fadeIn(duration: 0.3)
            )
            
            let imageRequest = ImageRequest(url: url, processors: [
                ImageProcessors.Resize(size: CGSize(width: self.circleSize, height: self.circleSize)),
                ImageProcessors.Circle()
            ])
            Nuke.loadImage(with: imageRequest, options: options, into: imageView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let titleLabel = self.titleLabel, let imageView = self.imageView else { return }
        
        titleLabel.sizeToFit()
        
        titleLabel.frame = CGRect(x: (self.bounds.width-titleLabel.frame.size.width-Appearance.padding)/2, y: 0, width: titleLabel.frame.size.width + Appearance.padding, height: titleLabel.frame.size.height + Appearance.padding)
        imageView.frame = CGRect(x: (self.bounds.width-self.circleSize)/2, y: Appearance.padding*3, width: self.circleSize, height: self.circleSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
