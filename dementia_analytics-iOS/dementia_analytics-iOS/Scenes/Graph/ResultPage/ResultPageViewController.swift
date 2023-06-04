//
//  ResultPageViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import UIKit

class ResultPageViewController: UIViewController {
    private let dataManager = DataManager.shared
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private var resultPageView: ResultPageView {
        return self.view as! ResultPageView
    }
    
    override func loadView() {
        view = ResultPageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        guard let publisher = dataManager.analysis() else { return }
        publisher.receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.resultPageView.setResult(result: result.label)
            }
            .store(in: &cancellable)
    }
    
}
