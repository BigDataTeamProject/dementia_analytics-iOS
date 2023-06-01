//
//  TestComponent.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/31.
//

import UIKit

final class NumberPicker: UIPickerView  {
    var startZero: Bool = false
    var maxValue: Int = 0
    
    var selectedRow: Int {
        get {
            self.selectedRow(inComponent: 0)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NumberPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxValue + (startZero ? 1 : 0)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + (startZero ? 0 : 1))"
    }
}
