//
//  ManageDataViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/03.
//

import UIKit
import Combine
import FSCalendar

class ManageDataViewController: UIViewController {
    private lazy var selectedDate: Date = Date().toMidnight()
    private lazy var currentDateData: [DAData] = []
    private lazy var eventDates: [Date] = Array(DataManager.shared.healthKitData.keys)
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    lazy var storeDataViewButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "관리", style: .plain, target: self, action: #selector(showDataStoreView))
        button.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.bmEuljiro(18),
            NSAttributedString.Key.foregroundColor : UIColor.daOrange,
        ], for: .normal)
        return button
    }()
    
    private var manageDataView: ManageDataView {
        return self.view as! ManageDataView
    }
    
    override func loadView() {
        view =  ManageDataView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        self.navigationItem.title = "건강 데이터"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bmEuljiro(24)]
        self.navigationItem.rightBarButtonItem = storeDataViewButton
        
        self.manageDataView.collectionView.delegate = self
        self.manageDataView.collectionView.dataSource = self
        self.manageDataView.calendar.delegate = self
        self.manageDataView.calendar.dataSource = self
    }
    
    func saveData(_ data: DAData){
        DataManager.shared.saveData(data)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.manageDataView.collectionView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    func deleteData(_ data: DAData){
        DataManager.shared.deleteData(data)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.manageDataView.collectionView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    @objc func showDataStoreView(){
        let vc = StoreDataViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ManageDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ManageDataViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        self.currentDateData = (DataManager.shared.healthKitData[date] ?? [:])
            .values
            .map{ $0 }
            .sorted(by: { data1, data2 in
                return data1.type.rawValue < data2.type.rawValue
            })
        self.manageDataView.collectionView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.eventDates.contains(date){
            return 1
        }
        return 0
    }
}

extension ManageDataViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDateData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCollectionViewCell.identifier, for: indexPath) as? DataCollectionViewCell else {
            return UICollectionViewCell()
        }
        let data = currentDateData[indexPath.row]
        if let sameData = DataManager.shared.managedData[data.startDate]?[data.type] {
            cell.setData(data, add: false)
            cell.completion = {
                self.deleteData(data)
            }
        } else {
            cell.setData(data)
            cell.completion = {
                self.saveData(data)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: manageDataView.collectionView.frame.width - 20, height: 80)
    }
}
