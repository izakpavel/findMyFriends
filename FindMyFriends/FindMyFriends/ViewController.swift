//
//  ViewController.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 23.04.2021.
//

import UIKit
import Combine
import Mapbox
import BottomSheet

class ViewController: UIViewController, ActivityPresentable {

    let viewModel = MainViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private var users: [User] = []
    private var annotations: [UserAnnotation] = [] {
        didSet {
            if let annotations = self.mainView?.mapView?.annotations {
                self.mainView?.mapView?.removeAnnotations(annotations)
            }
            self.mainView?.mapView?.addAnnotations(self.annotations)
        }
    }
        
    var mainView: MainView? {
        return self.view as? MainView
    }
    
    let bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView?.displayToggle?.didChangeToggle = { [weak self] (value) in
            self?.mainView?.showTable = value
        }
        
        self.mainView?.userTable?.delegate = self
        self.mainView?.userTable?.dataSource = self
        self.mainView?.userTable?.registerCell(GenericViewCell<UserRowView>.self)
        self.mainView?.userTable?.separatorStyle = .none
        
        setupBindings()
        viewModel.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardNotifications(shouldRegister: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.keyboardNotifications(shouldRegister: false)
    }
    
    func setupBindings() {
        if let inputTextfield = self.mainView?.countView?.inputTextfield {
            self.viewModel.$requestUserCount.assign(to: \.text!, on: inputTextfield).store(in: &subscriptions)
        }
        
        viewModel.$users
                .sink { [weak self] users in
                    self?.users = users
                    self?.mainView?.userTable?.reloadData()
                    self?.annotations = users.map{ user in UserAnnotation(user: user) }
                }
                .store(in: &subscriptions)
        
        viewModel.$isLoading
                .sink { [weak self] isLoading in
                    self?.setActivityIndicatorState(visible: isLoading)
                }
                .store(in: &subscriptions)
        
        self.mainView?.countView?.inputTextfield?.setAction(for: .editingDidEnd) {
            self.viewModel.requestUserCount = self.mainView?.countView?.inputTextfield?.text ?? ""
            self.viewModel.load()
        }
    }
    
    // MARK: handling keyboard
    
    func keyboardNotifications(shouldRegister:Bool){
        if shouldRegister {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
                self.handleKeyboardNotification(notification: notification)
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) in
                self.handleKeyboardNotification(notification: notification)
            }
        } else {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    func handleKeyboardNotification(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        let duration: NSNumber = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber ?? NSNumber(0.3))
        let showNotification = notification.name == UIResponder.keyboardWillShowNotification ? true : false
        if (showNotification) {
            UIView.animate(withDuration: duration.doubleValue) {
                self.mainView?.inputPosition = .expanded(keyboardRect.height)
                self.mainView?.layoutIfNeeded()
            }
        }
        else {
            UIView.animate(withDuration: duration.doubleValue) {
                self.mainView?.inputPosition = .small
                self.mainView?.layoutIfNeeded()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(forIndexPath: indexPath) as GenericViewCell<UserRowView>
        cell.padding = Appearance.padding
        let user = self.users[indexPath.row]
        cell.cellView?.setUser(user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        self.presentBottomSheetWithUser(user)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: MGLMapViewDelegate {
}

extension ViewController: BottomSheetPresenter {
    
    func presentBottomSheet() {
        let controller = BottomSheetViewController()
        
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: presenting bottom sheet
    
    func presentBottomSheetWithUser(_ user: User) {
        let controller = BottomSheetViewController()
        controller.transitioningDelegate = bottomSheetTransitioningDelegate
        
        let userDetailView = UserDetailView()
        userDetailView.setUser(user)
        controller.contentView = userDetailView
        
        controller.sheetSizingStyle = .adaptive//.fixed(height: 300)
        controller.handleStyle = .inside
        controller.handleColor = Appearance.highlightColor
        controller.contentInsets = UIEdgeInsets(top: Appearance.padding, left: 0, bottom: Appearance.padding, right: 0)
        self.present(controller, animated: true, completion: nil)
    }
}
