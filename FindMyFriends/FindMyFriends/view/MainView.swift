//
//  MainView.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 23.04.2021.
//

import Foundation
import UIKit


class MainView: UIView {
    weak var userTable: UITableView?
    weak var mapView: UIView?
    weak var displayToggle: UISwitch?
    weak var inputTextfield: UITextField?
    
    var showTable: Bool = false {
        didSet { self.userTable?.setVisibilityAnimated(self.showTable) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
        
    func commonInit() {
        
        let mapView = UIView()
        mapView.backgroundColor = UIColor.blue
        self.mapView = mapView
        
        let userTable = UITableView(frame: CGRect(), style: .plain)
        userTable.backgroundColor = UIColor.orange
        self.userTable = userTable
        
        let displayToggle = UISwitch()
        self.displayToggle = displayToggle
        
        let inputTextfield = UITextField()
        self.inputTextfield = inputTextfield
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        [mapView, userTable, displayToggle, inputTextfield].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.addConstraints(userTable.pinToSuperviewConstraints())
        self.addConstraints(mapView.pinToSuperviewConstraints())
        
        let padding:CGFloat = 16
        
        displayToggle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding).isActive = true
        displayToggle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding).isActive = true
        
        inputTextfield.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding).isActive = true
        inputTextfield.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding).isActive = true
        
        displayToggle.heightAnchor.constraint(equalToConstant: 44).isActive = true
        inputTextfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        // will remove
        displayToggle.widthAnchor.constraint(equalToConstant: 44).isActive = true
        inputTextfield.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
}
