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

    func commonInit() {
        self.backgroundColor = UIColor.systemBackground
        self.layer.shadowColor = UIColor.secondaryLabel.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize()
        
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        stackView.alignment = .center
        stackView.axis = .horizontal
        
        self.stackView = stackView
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("No. of users", comment: "User input prefix")
        titleLabel.textColor = UIColor.secondaryLabel
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.titleLabel = titleLabel
        
        let inputTextfield = UITextField()
        inputTextfield.textColor = UIColor.label
        inputTextfield.font = UIFont.preferredFont(forTextStyle: .headline)
        inputTextfield.keyboardType = .decimalPad
        self.inputTextfield = inputTextfield
        
        [titleLabel, inputTextfield].forEach{
            stackView.addArrangedSubview($0)
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(stackView.pinToSuperviewConstraints(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)))
    }
}
