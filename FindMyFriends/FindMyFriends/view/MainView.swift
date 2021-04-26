//
//  MainView.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 23.04.2021.
//

import Foundation
import UIKit
import Mapbox


class MainView: UIView {
    weak var userTable: UITableView?
    weak var mapView: MGLMapView?
    weak var displayToggle: UISwitch?
    weak var countView: InputView?
    
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
        
        let mapView = MGLMapView()
        mapView.backgroundColor = UIColor.blue
        self.mapView = mapView
        
        let userTable = UITableView(frame: CGRect(), style: .plain)
        userTable.backgroundColor = UIColor.orange
        self.userTable = userTable
        
        let displayToggle = UISwitch()
        self.displayToggle = displayToggle
        
        let countView = InputView()
        self.countView = countView
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        [mapView, userTable, displayToggle, countView].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.addConstraints(userTable.pinToSuperviewConstraints())
        self.addConstraints(mapView.pinToSuperviewConstraints())
        
        let padding:CGFloat = 16
        
        displayToggle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding).isActive = true
        displayToggle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding).isActive = true
        
        countView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding).isActive = true
        countView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding).isActive = true
        
        displayToggle.heightAnchor.constraint(equalToConstant: 44).isActive = true
        countView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        // will remove
        displayToggle.widthAnchor.constraint(equalToConstant: 44).isActive = true
        //countView.widthAnchor.constraint(equalToConstant: 144).isActive = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            endEditing(true)
        }
    }
}
