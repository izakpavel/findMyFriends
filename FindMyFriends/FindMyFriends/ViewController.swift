//
//  ViewController.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 23.04.2021.
//

import UIKit

class ViewController: UIViewController {

    var mainView: MainView? {
        return self.view as? MainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.mainView?.inputTextfield?.text = "ABC"
        self.mainView?.displayToggle?.setAction (for: UIControl.Event.valueChanged, { [weak self] in
            self?.mainView?.showTable = self?.mainView?.displayToggle?.isOn ?? false
        })
    }


}

