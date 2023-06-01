//
//  SettingsViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var testView: SettingsView {
        return self.view as! SettingsView
    }
    
    override func loadView() {
        view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
