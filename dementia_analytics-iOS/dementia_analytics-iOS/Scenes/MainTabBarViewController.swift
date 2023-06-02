//
//  MainTabBarViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    private let homeVC: HomeViewController = HomeViewController()
    private let graphVC: GraphViewController = GraphViewController()
    private let settingsVC: SettingsViewController = SettingsViewController()
    
    let HEIGHT_TAB_BAR:CGFloat = 100
    
    init(){
        super.init(nibName: nil, bundle: nil)
        // showLaunchView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        homeVC.title = StringCollection.home
        graphVC.title = StringCollection.graph
        settingsVC.title = StringCollection.settings
        
        homeVC.tabBarItem.image = UIImage.init(systemName: "house")
        graphVC.tabBarItem.image = UIImage.init(systemName: "chart.xyaxis.line")
        settingsVC.tabBarItem.image = UIImage.init(systemName: "gear")
        
        setViewControllers([homeVC, graphVC, settingsVC], animated: false)
    }
    
    func configure(){
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity =  0.5
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBar.layer.shadowRadius = 2.0
        tabBar.layer.shadowPath = UIBezierPath(roundedRect:tabBar.bounds, cornerRadius: tabBar.layer.cornerRadius).cgPath
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = HEIGHT_TAB_BAR
        tabFrame.origin.y = self.view.frame.size.height - HEIGHT_TAB_BAR
        self.tabBar.frame = tabFrame
    }
    
    private func showLaunchView(){
        let launchView: LaunchView = LaunchView()
        view.addSubview(launchView)
        launchView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            launchView.topAnchor.constraint(equalTo: self.view.topAnchor),
            launchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            launchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            launchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        launchView.animationPlay {
            launchView.removeFromSuperview()
        }
    }
    
}
