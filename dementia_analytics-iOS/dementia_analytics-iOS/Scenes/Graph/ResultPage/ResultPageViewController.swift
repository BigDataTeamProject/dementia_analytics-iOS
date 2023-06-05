//
//  ResultPageViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import UIKit
import Combine

class ResultPageViewController: UIViewController {
    private let dataManager = DataManager.shared
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private var resultPageView: ResultPageView {
        return self.view as! ResultPageView
    }
    
    override func loadView() {
        view = ResultPageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let publisher = dataManager.analysis() else { return }
        publisher.receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.resultPageView.setResult(result: result.label)
            }
            .store(in: &cancellable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure(){
        
    }
    
}
