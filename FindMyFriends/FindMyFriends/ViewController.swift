//
//  ViewController.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 23.04.2021.
//

import UIKit
import Combine

class ViewController: UIViewController {

    let viewModel = MainViewModel()
    private var subscriptions = Set<AnyCancellable>()
        
    var mainView: MainView? {
        return self.view as? MainView
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.mainView?.countView?.inputTextfield?.text = "ABC"
        self.mainView?.displayToggle?.setAction (for: UIControl.Event.valueChanged, { [weak self] in
            self?.mainView?.showTable = self?.mainView?.displayToggle?.isOn ?? false
        })
        
        self.mainView?.userTable?.delegate = self
        self.mainView?.userTable?.dataSource = self
        
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
            
        let showNotification = notification.name == UIResponder.keyboardWillShowNotification ? true : false
        if (showNotification) {
            UIView.animate(withDuration: 0.3) {
                self.mainView?.inputPosition = .expanded(keyboardRect.height)
                self.mainView?.layoutIfNeeded()
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.mainView?.inputPosition = .small
                self.mainView?.layoutIfNeeded()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

