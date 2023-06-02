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
        homeView.homeButton.addTarget(self, action: #selector(showTestView), for: .touchUpInside)
    }
}

extension HomeViewController {
    @objc
    func showTestView(){
        DementiaAnalyticsModel.shared.read()
        navigationController?.pushViewController(GraphViewController(nibName: nil, bundle: nil), animated: true)
        // if let url = URL(string: UIApplication.openSettingsURLString) {
        //     UIApplication.shared.open(url)
        // }
    }
}

