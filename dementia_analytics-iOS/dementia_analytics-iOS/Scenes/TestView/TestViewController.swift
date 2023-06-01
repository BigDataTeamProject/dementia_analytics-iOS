//
//  TestViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/30.
//

import UIKit

class TestViewController: UIViewController {
    private var testView: TestView {
        return self.view as! TestView
    }
    
    override func loadView() {
        view =  TestView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   

}
