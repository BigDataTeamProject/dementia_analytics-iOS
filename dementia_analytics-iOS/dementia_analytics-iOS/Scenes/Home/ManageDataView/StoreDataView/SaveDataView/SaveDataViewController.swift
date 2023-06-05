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
    private let datatypes: [DADataType] = [
        .sleepBreathAverage,
        .sleepHrAverage,
        .sleepHrLowest,
        .sleepDeep,
        .sleepRem,
        .activityCalTotal,
        .sleepAwake,
        .activitySteps,
        .activityTotal,
        .sleepDuration,
        .activityDailyMovement]
    private var startDate: Date
    private var type: DADataType = .sleepBreathAverage
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
        self.saveDataView.valueInput.delegate = self
        self.saveDataView.valueInput
            .addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.saveDataView.typePicker.delegate = self
        self.saveDataView.typePicker.dataSource = self
        
        self.saveDataView.storeAction = {
            guard let value = self.value else { return }
            DataManager.shared.saveData(DAData(type: self.type,
                                               startDate: self.startDate,
                                               endDate: self.startDate.addDate(byAddning: .day,
                                                                               value: 1),
                                               value: value))
            .receive(on: DispatchQueue.main)
            .sink { result in
                print(result)
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

extension SaveDataViewController: UIPickerViewDelegate,
                                  UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.datatypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.type = datatypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = .bmEuljiro(20)
        label.text = datatypes[row].title
        label.textAlignment = .center
        return label
    }
}
