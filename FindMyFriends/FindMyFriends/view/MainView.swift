//
//  MainView.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 23.04.2021.
//

import Foundation
import UIKit
import Mapbox

enum InputPosition {
    case expanded (CGFloat)
    case small
}

class MainView: UIView {
    weak var userTable: UITableView?
    weak var mapView: MGLMapView?
    weak var displayToggle: ToggleView?
    weak var countView: InputView?
    weak var confirmButton: UIButton?
    weak var overlayView: UIView?
    
    private var inputConstraintWidth: NSLayoutConstraint?
    private var inputConstraintTrailing: NSLayoutConstraint?
    private var inputConstraintBottom: NSLayoutConstraint?
    private var buttonConstraintBottom: NSLayoutConstraint?
    
    var showTable: Bool = false {
        didSet {
            //self.userTable?.setVisibilityAnimated(self.showTable)
            self.showTableAnimated(showTable)
            self.userTable?.flashScrollIndicators()
        }
    }
    
    func showTableAnimated(_ visible: Bool) {
        guard let table = self.userTable, let map = self.mapView else { return }
        if (!visible) {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
                table.alpha = 0.0
                table.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 44, y: 0)
                map.transform = CGAffineTransform(scaleX: 1, y: 1)
            } completion: { (completed) in
                if (completed) {
                    table.isHidden = true
                }
            }
        }
        else {
            table.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
                table.alpha = 1.0
                table.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                map.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: -44, y: 0)
            } completion: { (completed) in
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    var inputPosition: InputPosition = .small {
        didSet {
            self.countView?.inputPosition = self.inputPosition
            switch self.inputPosition {
            case .small:
                self.inputConstraintWidth?.constant = 44
                self.inputConstraintBottom?.constant = -Appearance.padding
                self.inputConstraintTrailing?.constant = -Appearance.padding
                self.countView?.titleLabel?.isHidden = true
                self.countView?.titleLabel?.alpha = 0
                self.confirmButton?.alpha = 0
                self.overlayView?.alpha = 0
                self.buttonConstraintBottom?.constant = 44
                self.confirmButton?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                
            case .expanded(let bottomOffset):
                self.inputConstraintWidth?.constant = self.superview?.bounds.width ?? 0
                self.inputConstraintBottom?.constant = -bottomOffset
                self.inputConstraintTrailing?.constant = 0
                self.countView?.titleLabel?.isHidden = false
                self.countView?.titleLabel?.alpha = 1
                self.confirmButton?.alpha = 1
                self.overlayView?.alpha = 1
                self.buttonConstraintBottom?.constant = -Appearance.padding
                self.confirmButton?.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
    }
        
    func commonInit() {
        
        let mapView = MGLMapView()
        self.mapView = mapView
        
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        overlayView.addGestureRecognizer(tapRecognizer)

        self.overlayView = overlayView
        
        let userTable = UITableView(frame: CGRect(), style: .plain)
        userTable.tableFooterView = UIView()
        userTable.separatorStyle = .none
        userTable.isHidden = true
        
        self.userTable = userTable
        
        let displayToggle = ToggleView()
        self.displayToggle = displayToggle
        
        let countView = InputView()
        self.countView = countView
        
        let confirmButton = UIButton()
        confirmButton.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))?.withRenderingMode(.alwaysTemplate), for: .normal)
        confirmButton.imageView?.tintColor = UIColor.white
        confirmButton.layer.cornerRadius = 22
        confirmButton.layer.masksToBounds = true
        confirmButton.backgroundColor = Appearance.accentColor
        confirmButton.setAction {
            self.endEditing(true)
        }
        self.confirmButton = confirmButton
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        [mapView, userTable, overlayView, displayToggle, confirmButton, countView].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.addConstraints(userTable.pinToSuperviewConstraints())
        self.addConstraints(mapView.pinToSuperviewConstraints())
        self.addConstraints(overlayView.pinToSuperviewConstraints())
        
        let padding:CGFloat = Appearance.padding
        
        displayToggle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding).isActive = true
        displayToggle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding).isActive = true
        displayToggle.heightAnchor.constraint(equalTo: countView.heightAnchor).isActive = true
        displayToggle.widthAnchor.constraint(greaterThanOrEqualToConstant: 128).isActive = true
        
        let inputConstraintTrailing = countView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)
        self.inputConstraintTrailing = inputConstraintTrailing
        
        let inputConstraintBottom = countView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        self.inputConstraintBottom = inputConstraintBottom
        
        let inputConstraintWidth = countView.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        self.inputConstraintWidth = inputConstraintWidth
        
        let buttonConstraintBottom = confirmButton.bottomAnchor.constraint(equalTo: countView.topAnchor, constant: -padding)
        self.buttonConstraintBottom = buttonConstraintBottom
        
        self.addConstraints([inputConstraintTrailing, inputConstraintBottom, inputConstraintWidth, buttonConstraintBottom])
        
        confirmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.inputPosition = .small
        self.showTable = false
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        let insets = self.userTable?.contentInset ?? UIEdgeInsets()
        self.userTable?.contentInset = UIEdgeInsets(top: insets.top, left: 0, bottom: 44 + 2*Appearance.padding, right: 0)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            endEditing(true)
        }
    }
}
