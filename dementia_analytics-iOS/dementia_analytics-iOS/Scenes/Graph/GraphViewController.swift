//
//  GraphViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    
    private var graphView: GraphView {
        return self.view as! GraphView
    }
    
    override func loadView() {
        view =  GraphView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        graphView.collectionView.delegate = self
        graphView.collectionView.dataSource = self
    }
}

extension GraphViewController: UICollectionViewDelegate,
                               UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.identifier, for: indexPath)
        cell.backgroundColor = .daGreen
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: graphView.collectionView.frame.width, height: graphView.collectionView.frame.height)
    }
    
}
