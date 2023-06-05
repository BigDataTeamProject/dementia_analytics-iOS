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
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    private let detectDismiss = PassthroughSubject<Bool, Never>()
    
    private var url: String = URLManager.shared.url
    
    
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
        
        self.settingsView.changeURLButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
    }
    
    func loadUserData(){
        DataManager.shared.readUser()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                self?.user = user
                self?.settingsView.setUser(user: user)
            })
            .store(in: &cancellable)
    }
    
    @objc func showAlert(){
        let alert = UIAlertController(title: "URL", message: "URL을 입력하세요", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            self.url = URLManager.shared.url
            textField.text = self.url
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        })
        
        let save = UIAlertAction(title: "저장", style: .default, handler: { _ in
            URLManager.shared.url = self.url
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(save)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ sender: Any){
        if let textfield = sender as? UITextField {
            if let text = textfield.text {
                self.url = text
            }
        }
    }
}
