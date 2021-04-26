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
    
    func setupBindings() {
        if let inputTextfield = self.mainView?.countView?.inputTextfield {
            self.viewModel.$requestUserCount.assign(to: \.text!, on: inputTextfield).store(in: &subscriptions)
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

