//
//  HomeViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/01.
//

import UIKit

class HomeViewController: UIViewController {
    private var homeView: HomeView {
        return self.view as! HomeView
    }
    
    override func loadView() {
        view =  HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        homeView.homeButton.addTarget(self, action: #selector(showManageDataView), for: .touchUpInside)
    }
}

extension HomeViewController {
    @objc
    func showManageDataView(){
        let vc = ManageDataViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

