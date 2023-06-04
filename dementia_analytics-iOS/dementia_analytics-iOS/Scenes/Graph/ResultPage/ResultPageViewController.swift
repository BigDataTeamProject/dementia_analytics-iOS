//
//  ResultPageViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import UIKit

class ResultPageViewController: UIViewController {
    private let dataManager = DataManager.shared
    
    private var resultPageView: ResultPageView {
        return self.view as! ResultPageView
    }

    override func loadView() {
        view = ResultPageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        dataManager.analysis()
    }

}
