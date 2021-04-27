//
//  UserDetailView.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 27.04.2021.
//

import Foundation
import UIKit
import Nuke

struct UserDisplayItem {
    let iconName: String?
    let titleText: String?
    let detailText:String?
}

extension User {
    func displayItems()->[[UserDisplayItem]] {
        var retArray = [[UserDisplayItem]]()
        let gender = self.gender?.localizedTitle
        
        let age = "\(self.dob?.age ?? 0)"
        let title = [gender, age].compactMap { $0 }.joined(separator: ", ")
        retArray.append([UserDisplayItem(iconName: "calendar", titleText: title, detailText: self.dob?.formattedDate())])
        
        let street = ["\(self.location?.street?.number ?? 0)", self.location?.street?.name].compactMap { $0 }.joined(separator: " ")
        let country = [self.location?.city, self.location?.state].compactMap { $0 }.joined(separator: ", ")
        retArray.append([UserDisplayItem(iconName: "mappin", titleText: street, detailText: country)])
        
        let contactArray = [UserDisplayItem(iconName: "phone", titleText: self.cell, detailText: nil),
                            UserDisplayItem(iconName: "envelope", titleText: self.email, detailText: nil)]
        
        retArray.append(contactArray)
        
        return retArray
    }
}

class UserDetailView: UIStackView, UITableViewDelegate, UITableViewDataSource {
    
    weak var imageView: UIImageView?
    weak var titleLabel: UILabel?
    weak var detailLabel: UILabel?
    weak var mainTable: IntrinsicTableView?
    weak var footerLabel: UILabel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    func commonInit() {
        
        self.distribution = .equalSpacing
        self.spacing = Appearance.padding/2
        self.alignment = .center
        self.axis = .vertical
        self.backgroundColor = Appearance.backgroundColor
        
        let titleLabel = UILabel()
        titleLabel.textColor = Appearance.primaryTextColor
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.numberOfLines = 0
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        self.titleLabel = titleLabel
        
        let detailLabel = UILabel()
        detailLabel.textColor = Appearance.secondaryTextColor
        detailLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        detailLabel.numberOfLines = 0
        self.detailLabel = detailLabel
        
        let footerLabel = UILabel()
        footerLabel.textColor = Appearance.secondaryTextColor
        footerLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        footerLabel.numberOfLines = 0
        self.footerLabel = footerLabel
        
        let imageView = UIImageView()
        self.imageView = imageView
        
        let mainTable = IntrinsicTableView(frame: CGRect(), style: .insetGrouped)
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.backgroundColor = Appearance.backgroundColor
        mainTable.backgroundView = nil
        self.mainTable = mainTable
        
        
        [imageView, titleLabel, detailLabel, mainTable, footerLabel].forEach {
            self.addArrangedSubview($0)
        }
        
        mainTable.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 2*Appearance.padding).isActive = true
        detailLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Appearance.padding).isActive = true
    }
    
    var userDisplayItems: [[UserDisplayItem]] = []
    
    func setUser(_ user: User) {
        self.titleLabel?.text = user.name?.fullName
        self.detailLabel?.text = user.login?.username
        
        if let url = URL(string: user.picture?.large ?? ""), let imageView = self.imageView {
            let options = ImageLoadingOptions(
              placeholder: UIImage(named: "placeholder"),
              transition: .fadeIn(duration: 0.3)
            )
            
            let imageRequest = ImageRequest(url: url, processors: [
                ImageProcessors.Resize(size: CGSize(width: 128, height: 128)),
                ImageProcessors.Circle()
            ])
            Nuke.loadImage(with: imageRequest, options: options, into: imageView)
        }
        if let formattedRegistration = user.registered?.formattedDate(dateStyle: .full, timeStyle: .long) {
            self.footerLabel?.text = "Registered on \(formattedRegistration)"
            self.footerLabel?.isHidden = false
        }
        else {
            self.footerLabel?.isHidden = true
        }
        
        self.userDisplayItems = user.displayItems()
        self.mainTable?.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.userDisplayItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userDisplayItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayItem = self.userDisplayItems[indexPath.section][indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "not needed")
        
        cell.backgroundColor = Appearance.highlightColor
        
        cell.textLabel?.text = displayItem.titleText
        cell.textLabel?.textColor = Appearance.primaryTextColor
        
        cell.detailTextLabel?.text = displayItem.detailText
        cell.detailTextLabel?.textColor = Appearance.secondaryTextColor
        
        if let iconName = displayItem.iconName {
            cell.imageView?.tintColor = Appearance.accentColor
            cell.imageView?.image = UIImage.init(systemName: iconName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))?.withRenderingMode(.alwaysTemplate)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Appearance.padding
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Appearance.padding
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
