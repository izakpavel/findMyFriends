//
//  InputView.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 26.04.2021.
//

import Foundation
import UIKit

class InputView: UIView {
    weak var stackView: UIStackView?
    weak var titleLabel: UILabel?
    weak var inputTextfield: UITextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    var inputPosition: InputPosition?

    func commonInit() {
        self.backgroundColor = Appearance.backgroundColor
        self.layer.shadowColor = Appearance.shadowColor.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize()
        
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = Appearance.padding
        stackView.alignment = .center
        stackView.axis = .horizontal
        
        self.stackView = stackView
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("No. of users", comment: "User input prefix")
        titleLabel.textColor = Appearance.secondaryTextColor
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.titleLabel = titleLabel
        
        let inputTextfield = UITextField()
        inputTextfield.textColor = Appearance.primaryTextColor
        inputTextfield.font = UIFont.preferredFont(forTextStyle: .headline)
        inputTextfield.keyboardType = .decimalPad
        inputTextfield.textAlignment = .center
        self.inputTextfield = inputTextfield
        
        [titleLabel, inputTextfield].forEach{
            stackView.addArrangedSubview($0)
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(stackView.pinToSuperviewConstraints(insets: UIEdgeInsets(top: Appearance.padding, left: Appearance.padding, bottom: Appearance.padding, right: Appearance.padding)))
        
        inputTextfield.widthAnchor.constraint(greaterThanOrEqualTo: inputTextfield.heightAnchor, multiplier: 1.0).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if case .small = self.inputPosition {
            self.layer.cornerRadius = self.bounds.height/2
        }
        else {
            self.layer.cornerRadius = 0
        }
        
    }
}
