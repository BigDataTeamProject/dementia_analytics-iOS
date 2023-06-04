//
//  GraphViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    private var chartPageViewControllerList: [UIViewController] = {
        let viewControllers = [DADataType.activityCalTotal,
                               DADataType.activityDailyMovement,
                               DADataType.activitySteps,
                               DADataType.activityTotal,
                               DADataType.sleepRem,
                               DADataType.sleepDeep,
                               DADataType.sleepAwake,
                               DADataType.sleepDuration,
                               DADataType.sleepHrLowest,
                               DADataType.sleepHrAverage,
                               DADataType.sleepBreathAverage
        ].enumerated().compactMap{ idx, type in
            let chartPageViewController =  ChartPageViewController()
            chartPageViewController.view.tag = idx + 1
            chartPageViewController.setDataType(dataType: type)
            return chartPageViewController
        }
        return viewControllers
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return pageViewController
    }()
    
    private var graphView: GraphView {
        return self.view as! GraphView
    }
    
    override func loadView() {
        let graphView = GraphView()
        graphView.setPageView(pageView: pageViewController.view)
        view = graphView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        self.addChild(pageViewController)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        if let firstVC = chartPageViewControllerList.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension GraphViewController: UIPageViewControllerDelegate,
                               UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = chartPageViewControllerList
            .compactMap({ $0.view.tag })
            .firstIndex(of: viewController.view.tag) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
        return chartPageViewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = chartPageViewControllerList
            .compactMap({ $0.view.tag })
            .firstIndex(of: viewController.view.tag) else { return nil }
        let nextIndex = index + 1
        if nextIndex == chartPageViewControllerList.count { return nil }
        return chartPageViewControllerList[nextIndex]
    }
}
