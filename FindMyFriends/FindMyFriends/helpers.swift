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

