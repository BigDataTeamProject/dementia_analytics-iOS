//
//  ChartPageView.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import UIKit
import Charts

final class ChartPageView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bmEuljiro(32)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var lineChartView: LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.noDataText = "데이터가 없습니다."
        lineChartView.noDataFont = .bmEuljiro(20)
        lineChartView.noDataTextColor = .daGray
        return lineChartView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .bmEuljiro(20)
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        configure()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
    
    private func addSubviews() {
        [titleLabel, lineChartView, descriptionLabel].forEach { view in
            self.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        [titleLabel, lineChartView, descriptionLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            lineChartView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                   constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                   constant: -20),
            lineChartView.heightAnchor.constraint(equalTo: lineChartView.widthAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                   constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                   constant: -30),
            titleLabel.bottomAnchor.constraint(equalTo: lineChartView.topAnchor,
                                               constant: -30),
            descriptionLabel.topAnchor.constraint(equalTo: lineChartView.bottomAnchor,
                                                  constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                   constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                   constant: -20),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setData(title: String, desc: String){
        self.titleLabel.text = title
        self.descriptionLabel.text = desc
        layoutIfNeeded()
    }
}
