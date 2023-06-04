//
//  UpdateProfileViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/02.
//

import UIKit
import Combine
import CoreDataStorage

class UpdateProfileViewController: UIViewController {
    private var name: String? = nil
    private var age: Int? = nil
    private var height: CGFloat? = nil
    private var weight: CGFloat? = nil
    
    private var user: User? = nil
    private let storage = CoreDataStorage.shared(name: "DementiaDataStorage")
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var dismissAlert: PassthroughSubject<Bool, Never>? = nil
    
    private var updateProfileView: UpdateProfileView {
        return self.view as! UpdateProfileView
    }
    
    override func loadView() {
        view = UpdateProfileView()
    }
    
    init(user:User?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        self.updateProfileView.nameInput.delegate = self
        self.updateProfileView.ageInput.delegate = self
        self.updateProfileView.heightInput.delegate = self
        self.updateProfileView.weightInput.delegate = self
        self.updateProfileView.nameInput
            .addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.updateProfileView.ageInput
            .addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.updateProfileView.heightInput
            .addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.updateProfileView.weightInput
            .addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.updateProfileView.setUser(user: user)
        self.name = user?.name
        self.age = user?.age
        self.height = user?.height
        self.weight = user?.weight
        
        self.updateProfileView.storeAction = {
            guard let name = self.name,
                  let age = self.age,
                  let height = self.height,
                  let weight = self.weight else { return }
            DataManager.shared.createUser(user: User(name: name,
                                                     age: age,
                                                     height: height,
                                                     weight: weight))
                .receive(on: DispatchQueue.main)
                .sink { user in
                    self.dismissAlert?.send(true)
                    self.dismiss(animated: true)
                }
                .store(in: &self.cancellable)
        }
        
        self.updateProfileView.cancelAction = {
            self.dismissAlert?.send(true)
            self.dismiss(animated: true)
        }
    }
    
}

extension UpdateProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
    @objc func textFieldDidChange(_ sender: Any){
        if let textfield = sender as? UITextField {
            if let text = textfield.text{
                switch textfield.tag {
                case 0: self.name = text
                case 1: self.age = Int(text)
                case 2: self.height = CGFloat((text as NSString).floatValue)
                case 3: self.weight = CGFloat((text as NSString).floatValue)
                default: break
                }
            }
        }
    }
}
