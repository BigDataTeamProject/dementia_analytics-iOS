//
//  SettingsViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import UIKit
import Combine
import CoreDataStorage

class SettingsViewController: UIViewController {
    private var user: User? = nil
    private let storage = CoreDataStorage.shared(name: "DementiaDataStorage")
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    private let detectDismiss = PassthroughSubject<Bool, Never>()
    
    
    private var settingsView: SettingsView {
        return self.view as! SettingsView
    }
    
    override func loadView() {
        view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        configure()
    }
    
    func configure(){
        self.detectDismiss
            .sink { [weak self] isDismiss in
            if isDismiss {
                self?.loadUserData()
            }
        }
        .store(in: &cancellable)
        
        self.settingsView.showUpdateProfile = { [weak self] in
            guard let self = self else { return }
            let updateProfileVC = UpdateProfileViewController(user: self.user)
            updateProfileVC.dismissAlert = self.detectDismiss
            self.present(updateProfileVC, animated: true)
            
        }
        
        self.settingsView.moveToSetting = {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func loadUserData(){
        storage.read(type: User.self)
            .receive(on: DispatchQueue.main)
            .map{ user -> User? in user.count > 0 ?  user[0] : nil }
            .replaceError(with: nil)
            .sink(receiveValue: { [weak self] user in
                self?.user = user
                self?.settingsView.setUser(user: user)
            })
            .store(in: &cancellable)
    }
}
