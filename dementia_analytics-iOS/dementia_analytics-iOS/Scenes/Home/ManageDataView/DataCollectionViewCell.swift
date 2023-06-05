//
//  DataCollectionViewCell.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import UIKit

final class DataCollectionViewCell: UICollectionViewCell {
    static let identifier: String = String(describing: DataCollectionViewCell.self)
    var completion: (()->Void)? = nil
    
    private let typeLabel: UILabel = {
       let label = UILabel()
        label.font = .bmEuljiro(20)
        return label
    }()
    
    private let valueLabel: UILabel = {
       let label = UILabel()
        label.font = .bmEuljiro(18)
        label.textAlignment = .right
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.titleLabel?.font = .bmEuljiro(18)
        button.clipsToBounds = true
        return button
    }()
    
    override func prepareForReuse() {
        self.backgroundColor = .daGray
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        configure()
        addSubviews()
        makeConstraints()
    }
    
    private func configure() {
        
    }
    
    private func addSubviews() {
        [typeLabel, valueLabel, button].forEach{ view in
            self.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        [typeLabel, valueLabel, button].forEach{ view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        let constraints: [NSLayoutConstraint] = [
            typeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            typeLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -20),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            button.widthAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    func setData(_ daData: DAData, add: Bool = true){
        typeLabel.text = daData.type.title
        
        var desc = ""
        let value = daData.value
        switch daData.type {
        case .sleepBreathAverage, .sleepHrAverage, .sleepHrLowest:
            desc = "\(Int(value)) \(StringCollection.countUnit)"
        case .activityTotal, .sleepDuration, .sleepDeep, .sleepRem, .sleepAwake:
            let hour = Int(value/60)/60
            let minute = Int(value/60) - (hour * 60)
            desc = (hour > 0 ? "\(hour) \(StringCollection.hourUnit) " : "") + "\(minute) \(StringCollection.minuteUnit)"
        case .activityCalTotal:
            desc = "\(Int(value)) \(StringCollection.kcalUnit)"
        case .activitySteps:
            desc = "\(Int(value)) \(StringCollection.stepUnit)"
        case .activityDailyMovement:
            desc = "\(Int(value)) \(StringCollection.meterUnit)"
        default:
            break
        }
        
        valueLabel.text = desc
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        if add {
            self.button.setTitle(StringCollection.add, for: .normal)
            self.button.setBackgroundColor(.daGreen, for: .normal)
        } else {
            self.button.setTitle(StringCollection.del, for: .normal)
            self.button.setBackgroundColor(.daRed, for: .normal)
        }
        
        layoutIfNeeded()
    }
    
    @objc func buttonAction(){
        completion?()
    }
}
