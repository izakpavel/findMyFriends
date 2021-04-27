//
//  helpers.swift
//  FindMyFriends
//
// various helpers I took from my other projects
//
//  Created by Pavel Zak on 23.04.2021.
//

import Foundation
import UIKit

// MARK: autolayout support

extension UIView {

    func pinToSuperviewConstraints(insets: UIEdgeInsets = UIEdgeInsets()) -> [NSLayoutConstraint] {
        let metrics = ["left": insets.left, "top": insets.top, "right": insets.right, "bottom": insets.bottom]
        var pinConstraints = [NSLayoutConstraint]()
        pinConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[subview]-right-|", options: [], metrics: metrics, views: ["subview": self]))
        pinConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[subview]-bottom@999-|", options: [], metrics: metrics, views: ["subview": self]))
        return pinConstraints
    }
    
    func setVisibilityAnimated(_ visible: Bool) {
        if (!visible) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState) {
                self.alpha = 0.0
            } completion: { (completed) in
                if (completed) {
                    self.isHidden = true
                }
            }
        }
        else {
            self.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState) {
                self.alpha = 1.0
            } completion: { (completed) in
            }
        }
    }
}

// MARK: handling actions with callbacks

/// helper  object that helds reference to a closure, nothing more
@objc class ClosureSleeve: NSObject {
    var closure: (()->())? = nil

    @objc func invoke () {
        closure?()
    }
}

private var objectHandle: UInt8 = 0

extension UIControl {
    /// little extension to set a single closure for a single eventType
    // TODO: in case we will need to use it form multiple event types,we will need to store a dictionary instead of single ClosureSleeve
    var closureSleeve:ClosureSleeve {
        get {
            return objc_getAssociatedObject(self, &objectHandle) as? ClosureSleeve ?? ClosureSleeve()
        }
        set {
            objc_setAssociatedObject(self, &objectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        let closureSleeve = self.closureSleeve
        self.removeTarget(closureSleeve, action: nil, for: .allEvents)
        addTarget(closureSleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        closureSleeve.closure = closure
        self.closureSleeve = closureSleeve
    }
}

// MARK: ActivityPresentable

/// protocol to bring loading indicator in the main viewcontroller view
protocol ActivityPresentable {
    /// trigger indicator state
    func setActivityIndicatorState(visible: Bool, moveY: CGFloat)
}

extension ActivityPresentable {
    func setActivityIndicatorState(visible: Bool, moveY: CGFloat = 0.0) {
        return setActivityIndicatorState(visible: visible, moveY: moveY)
    }
}

extension ActivityPresentable where Self: UIViewController {
    
    func setActivityIndicatorState(visible: Bool, moveY: CGFloat = 0.0) {
        if visible {
            self.presentActivityIndicator(moveY: moveY)
        }
        else {
            self.dismissActivityIndicator()
        }
    }
    
    func presentActivityIndicator(moveY: CGFloat = 0.0) {
        if let activityIndicator = findActivityIndicator() {
            activityIndicator.startAnimating()
        } else {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            
            activityIndicator.startAnimating()
            view.addSubview(activityIndicator)

            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: moveY)
                ])
        }
    }

    func dismissActivityIndicator() {
        findActivityIndicator()?.stopAnimating()
    }

    func findActivityIndicator() -> UIActivityIndicatorView? {
        return view.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
    }
}

// MARK: GenericCell

class GenericViewCell<View: UIView> : UITableViewCell{
    var cellView: View?
    var pinConstraints: [NSLayoutConstraint] = []
    
    var padding: CGFloat {
        set {
            self.edgeInsets = UIEdgeInsets(top: newValue, left: newValue, bottom: newValue, right: newValue)
        }
        get {
            return self.edgeInsets.left
        }
    }

    var edgeInsets: UIEdgeInsets = UIEdgeInsets(){
        didSet {
            self.recreatePinConstraints()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        let cellView = View()
        self.contentView.addSubview(cellView)
        self.translatesAutoresizingMaskIntoConstraints = false
        cellView.translatesAutoresizingMaskIntoConstraints = false
        self.cellView = cellView
        self.recreatePinConstraints()
    }
    
    func recreatePinConstraints () {
        if let cellView = self.cellView {
            self.contentView.removeConstraints(self.pinConstraints)
            
            self.pinConstraints = cellView.pinToSuperviewConstraints(insets: self.edgeInsets)
            
            self.contentView.addConstraints(self.pinConstraints)
        }
    }
}

// MARK: Reusable

protocol Reusable {
    static var reuseId: String { get }
}

extension Reusable {
    static var reuseId: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable { }
extension UITableViewHeaderFooterView: Reusable {}
extension UICollectionViewCell: Reusable {}

extension UITableView {
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        if Bundle.main.path(forResource: cellClass.reuseId, ofType: "nib") != nil { // class available as xib
           register(UINib(nibName: cellClass.reuseId, bundle: nil), forCellReuseIdentifier: cellClass.reuseId)
        }
        else {
            register(cellClass, forCellReuseIdentifier: cellClass.reuseId)
        }
    }
    
    func registerHeaderFooter<HeaderFooter: UITableViewHeaderFooterView>(_ headerClass: HeaderFooter.Type) {
        if Bundle.main.path(forResource: headerClass.reuseId, ofType: "nib") != nil { // class available as xib
           register(UINib(nibName: headerClass.reuseId, bundle: nil), forHeaderFooterViewReuseIdentifier: headerClass.reuseId)
        }
        else {
            register(headerClass, forHeaderFooterViewReuseIdentifier:headerClass.reuseId)
        }
    }
    
    func dequeReusableCell<Cell: UITableViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        if let cell = self.dequeueReusableCell(withIdentifier: Cell.reuseId, for: indexPath) as? Cell {
            return cell
        }
        else {
            return Cell(style: .default, reuseIdentifier: Cell.reuseId)
        }
    }
    
    func dequeReusableHeaderFooterView<HeaderFooter: UITableViewHeaderFooterView>() -> HeaderFooter {
        if let headerFooter = self.dequeueReusableHeaderFooterView(withIdentifier: HeaderFooter.reuseId) as? HeaderFooter {
            return headerFooter
        }
        else {
            return HeaderFooter(reuseIdentifier: HeaderFooter.reuseId)
        }
    }
}


// MARK: IntrinsicTableView


final class IntrinsicTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
