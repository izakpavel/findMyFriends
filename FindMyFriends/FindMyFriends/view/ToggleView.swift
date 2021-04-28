//
//  ToggleView.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 27.04.2021.
//

import Foundation
import UIKit

class ToggleView: UIView {
    weak var leftView: UIButton?
    weak var rightView: UIButton?
    weak var highlightView: UIView?
    
    var didChangeToggle:((Bool)->())?
    
    private var highlightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    var toggleValue: Bool = false {
        didSet {
            self.leftView?.imageView?.tintColor = toggleValue ? Appearance.secondaryTextColor : Appearance.accentColor
            self.rightView?.imageView?.tintColor = !toggleValue ? Appearance.secondaryTextColor : Appearance.accentColor
            
            if let highlightConstraint = self.highlightConstraint {
                self.removeConstraint(highlightConstraint)
            }
            
            guard let leftView = self.leftView, let rightView = self.rightView, let highlightView = self.highlightView else { return }
            if toggleValue {
                self.highlightConstraint = highlightView.centerXAnchor.constraint(equalTo: rightView.centerXAnchor)
            }
            else {
                self.highlightConstraint = highlightView.centerXAnchor.constraint(equalTo: leftView.centerXAnchor)
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
                self.highlightConstraint?.isActive = true
                self.leftView?.transform = self.toggleValue ? CGAffineTransform(scaleX: 0.9, y: 0.9) : CGAffineTransform.identity
                self.rightView?.transform = !self.toggleValue ? CGAffineTransform(scaleX: 0.9, y: 0.9) : CGAffineTransform.identity
                self.layoutIfNeeded()
            }
        }
    }

    func commonInit() {
        self.backgroundColor = Appearance.backgroundColor
        self.layer.shadowColor = Appearance.shadowColor.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize()
        
        let highlightView = UIView()
        highlightView.backgroundColor = Appearance.highlightColor
        self.highlightView = highlightView
        
        let leftView = UIButton()
        leftView.imageView?.tintColor = Appearance.accentColor
        leftView.setImage(UIImage(systemName: "map", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
        self.leftView = leftView
        
        let rightView = UIButton()
        rightView.imageView?.tintColor = Appearance.accentColor
        rightView.setImage(UIImage(systemName: "list.bullet", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
        self.rightView = rightView
        
        
        let views = ["highlightView": highlightView, "leftview": leftView, "rightView": rightView]
        let metrics = ["inset": Appearance.padding/2, "highlightInset": Appearance.padding/4]
        
        views.values.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-inset-[leftview]-inset-[rightView(==leftview)]-inset-|", options: [.alignAllCenterY], metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-inset-[leftview]-inset-|", options: [], metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-inset-[rightView]-inset-|", options: [], metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-highlightInset-[highlightView]-highlightInset-|", options: [], metrics: metrics, views: views))
        
        highlightView.widthAnchor.constraint(equalTo: leftView.widthAnchor, multiplier: 1, constant: Appearance.padding/2).isActive = true
        
        self.highlightConstraint = self.highlightView?.centerXAnchor.constraint(equalTo: leftView.centerXAnchor)
        self.highlightConstraint?.isActive = true
        
        self.sendSubviewToBack(highlightView)
        
        leftView.setAction {
            self.toggleValue = false
            self.didChangeToggle?(false)
        }
        rightView.setAction {
            self.toggleValue = true
            self.didChangeToggle?(true)
        }
        
        self.toggleValue = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height/2
        self.highlightView?.layer.cornerRadius = (self.highlightView?.bounds.height ?? 0)/2
    }
}
