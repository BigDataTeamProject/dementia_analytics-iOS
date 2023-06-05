//
//  SaveDataViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/05.
//

import UIKit
import Combine
import CoreDataStorage

class SaveDataViewController: UIViewController {
    private var startDate: Date
    private var type: DADataType? = nil
    private var value: CGFloat? = nil
    
    private let storage = CoreDataStorage.shared(name: "DementiaDataStorage")
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var dismissAlert: PassthroughSubject<Bool, Never>? = nil
    
    private var saveDataView: SaveDataView {
        return self.view as! SaveDataView
    }
    
    override func loadView() {
        view = SaveDataView()
    }
    
    init(startDate: Date) {
        self.startDate = startDate
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
        
        self.saveDataView.storeAction = {
            guard let type = self.type,
                  let value = self.value else { return }
            DataManager.shared.saveData(DAData(type: type,
                                               startDate: self.startDate,
                                               endDate: self.startDate.addDate(byAddning: .day,
                                                                               value: 1),
                                               value: value))
            .receive(on: DispatchQueue.main)
            .sink { user in
                self.dismissAlert?.send(true)
                self.dismiss(animated: true)
            }
            .store(in: &self.cancellable)
        }
        
        self.saveDataView.cancelAction = {
            self.dismissAlert?.send(true)
            self.dismiss(animated: true)
        }
    }
}

extension SaveDataViewController: UITextFieldDelegate {
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
                self.value = CGFloat((text as NSString).floatValue)
            }
        }
    }
}
