//
//  StoreDataViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/05.
//

import UIKit
import Combine
import FSCalendar

class StoreDataViewController: UIViewController {
    private lazy var selectedDate: Date = Date().toMidnight()
    private lazy var currentDateData: [DAData] = []
    private lazy var eventDates: [Date] = Array(DataManager.shared.managedData.keys)
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private var storeDataView: StoreDataView {
        return self.view as! StoreDataView
    }
    
    override func loadView() {
        view =  StoreDataView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        self.navigationItem.title = "데이터 관리"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bmEuljiro(24)]
    
        self.storeDataView.collectionView.delegate = self
        self.storeDataView.collectionView.dataSource = self
        self.storeDataView.calendar.delegate = self
        self.storeDataView.calendar.dataSource = self
    }
    
    func deleteData(_ data: DAData){
        DataManager.shared.deleteData(data)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.storeDataView.collectionView.reloadData()
            }
            .store(in: &cancellable)
    }
}

extension StoreDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension StoreDataViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        self.currentDateData = (DataManager.shared.managedData[date] ?? [:])
            .values
            .map{ $0 }
            .sorted(by: { data1, data2 in
                return data1.type.rawValue < data2.type.rawValue
            })
        self.storeDataView.collectionView.reloadData()
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

extension StoreDataViewController: UICollectionViewDelegate,
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
        cell.setData(data, add: false)
        cell.completion = {
            self.deleteData(data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: storeDataView.collectionView.frame.width - 20, height: 80)
    }
}
