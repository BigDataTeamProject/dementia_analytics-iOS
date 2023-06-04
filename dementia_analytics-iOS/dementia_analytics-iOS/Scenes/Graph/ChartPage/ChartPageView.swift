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
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 2.0)
        lineChartView.xAxis.labelFont = .bmEuljiro(14)
        lineChartView.leftAxis.labelFont = .bmEuljiro(14)
        lineChartView.extraRightOffset = 20
        lineChartView.xAxis.drawGridLinesEnabled = false
        
        return lineChartView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .bmEuljiro(20)
        label.textAlignment = .center
        label.numberOfLines = 3
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
                                                   constant: 30),
            lineChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                    constant: -30),
            lineChartView.heightAnchor.constraint(equalTo: lineChartView.widthAnchor, multiplier: 1.2),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                 constant: -30),
            titleLabel.bottomAnchor.constraint(equalTo: lineChartView.topAnchor,
                                               constant: -30),
            descriptionLabel.topAnchor.constraint(equalTo: lineChartView.bottomAnchor,
                                                  constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                      constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                       constant: -20),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setData(title: String,
                 desc: NSMutableAttributedString,
                 x:[String]? = nil,
                 y:[CGFloat]? = nil,
                 cnAvg: CGFloat? = nil,
                 demAvg: CGFloat? = nil,
                 mciAvg: CGFloat? = nil){
        self.titleLabel.text = title
        self.descriptionLabel.attributedText = desc
        if let y = y, !y.isEmpty {
            let entries = y.enumerated().compactMap { (idx, value) in
                ChartDataEntry(x: Double(idx), y: Double(value))
            }
            let lineChartDataSet = LineChartDataSet(entries: entries,
                                                    label: title)
            lineChartDataSet.colors = [.daGreen]
            lineChartDataSet.mode = .cubicBezier
            lineChartDataSet.circleColors = [.daGreen]
            let gradientColors = [UIColor.daGreen.cgColor, UIColor.clear.cgColor]
            let colorLocations:[CGFloat] = [1.0, 0.0]
            if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                         colors: gradientColors as CFArray,
                                         locations: colorLocations){
                lineChartDataSet.fill = LinearGradientFill(gradient: gradient, angle: 90.0)
                lineChartDataSet.gradientPositions = colorLocations
                lineChartDataSet.drawFilledEnabled = true
            }
            
            if let x = x {
                self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: x)
                self.lineChartView.xAxis.setLabelCount(y.count, force: true)
            }
            lineChartView.data = LineChartData(dataSet: lineChartDataSet)
        }
        
        if let cnAvg = cnAvg {
            let cnLL = ChartLimitLine(limit: cnAvg, label: StringCollection.CN)
            cnLL.lineColor = .daRed
            lineChartView.leftAxis.addLimitLine(cnLL)
        }
        if let mciAvg = mciAvg {
            let mciLL = ChartLimitLine(limit: mciAvg, label: StringCollection.MCI)
            mciLL.lineColor = .daRed
            lineChartView.leftAxis.addLimitLine(mciLL)
        }
        if let demAvg = demAvg {
            let demLL = ChartLimitLine(limit: demAvg, label: StringCollection.DEM)
            demLL.lineColor = .daRed
            lineChartView.leftAxis.addLimitLine(demLL)
        }
        layoutIfNeeded()
    }
}
