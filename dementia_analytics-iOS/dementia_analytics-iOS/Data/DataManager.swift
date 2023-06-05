//
//  DataManager.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import Foundation
import Combine
import CoreData
import CoreDataStorage

final class DataManager {
    static let shared = DataManager()
    private let storage = CoreDataStorage.shared(name: "DementiaDataStorage")
    private let model = DementiaAnalyticsModel.shared
    private var cancellabel: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var healthKitData: [Date:[DADataType: DAData]] = [:]
    var managedData: [Date:[DADataType: DAData]] = [:]
    
    var auth: Bool {
        model.auth
    }
    var cnMean: Features? = nil
    var mciMean: Features? = nil
    var demMean: Features? = nil
    
    private init() { }
    
    func load(){
        guard let fileLocation = Bundle.main.url(forResource: "dataset_mean", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: fileLocation)
            guard let meanData = try? JSONDecoder().decode([String: Features].self,
                                                           from: data)
            else { return }
            cnMean = meanData["CN"]
            mciMean = meanData["MCI"]
            demMean = meanData["DEM"]
        } catch {
            print(error)
        }
        loadHealthKitData()
        loadManagedData()
    }
    
    func loadHealthKitData(){
        self.model.readActivitEnergyBurned()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] daData in
                guard let self = self else { return }
                self.saveHealthkitData(daData, type: .activityCalTotal, sum: true)
            }
            .store(in: &cancellabel)
        
        self.model.readBasalEnergyBurned()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] daData in
                guard let self = self else { return }
                self.saveHealthkitData(daData, type: .activityCalTotal, sum: true)
            }
            .store(in: &cancellabel)
        
        self.model.readStepCount()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] daData in
                guard let self = self else { return }
                self.saveHealthkitData(daData)
            }
            .store(in: &cancellabel)
        
        self.model.readSleepAnalysisData()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] daData in
                guard let self = self else { return }
                self.saveHealthkitData(daData)
            }
            .store(in: &cancellabel)
        
        self.model.readDistanceWalkingRunning()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] daData in
                guard let self = self else { return }
                self.saveHealthkitData(daData)
            }
            .store(in: &cancellabel)
    }
    
    private func saveHealthkitData(_ daData: [DAData]?, type: DADataType? = nil, sum: Bool = false){
        (daData ?? []).forEach{ data in
            var dataType = data.type
            if let newType = type {
                dataType = newType
            }
            if data.value > 0 {
                if self.healthKitData[data.startDate] == nil {
                    self.healthKitData[data.startDate] = [:]
                }
                if sum {
                    if self.healthKitData[data.startDate]![dataType] == nil {
                        self.healthKitData[data.startDate]![dataType] = DAData(type: dataType,
                                                                               startDate: data.startDate,
                                                                               endDate: data.endDate,
                                                                               value: data.value)
                    }
                    self.healthKitData[data.startDate]![dataType]! =  self.healthKitData[data.startDate]![dataType]!.sum(value: data.value)
                } else {
                    self.healthKitData[data.startDate]![dataType] = data
                }
            }
        }
    }
    
    private func loadManagedData() {
        self.managedData = [:]
        self.storage.read(type: DAData.self)
            .replaceError(with: [])
            .sink { datas in
                datas.forEach{ data in
                    if self.managedData[data.startDate] == nil {
                        self.managedData[data.startDate] = [:]
                    }
                    self.managedData[data.startDate]![data.type] =  data
                }
            }
            .store(in: &cancellabel)
    }
    
    func saveData(_ data: DAData) -> AnyPublisher<Bool, Never> {
        let predicate = NSPredicate(format: "startDate == %@ && type == %i",
                                    data.startDate as NSDate,
                                    data.type.rawValue)
        return storage.delete(DAData.self,
                              predicate: predicate)
        .map { _ -> Bool in true }
        .replaceError(with: false)
        .flatMap { _ in
            self.storage.create(data)
        }
        .map { _ -> Bool in true }
        .replaceError(with: false)
        .handleEvents(receiveOutput: { _ in
            self.loadManagedData()
        })
        .eraseToAnyPublisher()
    }
    
    func deleteData(_ data: DAData) -> AnyPublisher<Bool, Never> {
        let predicate = NSPredicate(format: "startDate == %@ && type == %i",
                                    data.startDate as NSDate,
                                    data.type.rawValue)
        return storage.delete(DAData.self,
                              predicate: predicate)
        .map { _ -> Bool in true }
        .replaceError(with: false)
        .handleEvents(receiveOutput: { a in
            self.loadManagedData()
        })
        .eraseToAnyPublisher()
    }
}

extension DataManager {
    func readUser() -> AnyPublisher<User?, Never>{
        return storage.read(type: User.self)
            .map { user -> User? in user.first }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    func createUser(user: User) -> AnyPublisher<User?, Never>{
        return self.storage.deleteAll(User.self)
            .flatMap { _ in
                return self.storage.create(user)
            }
            .map{ user -> User? in user }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

extension DataManager {
    func mean(dataType:DADataType) -> (CGFloat?,
                                       CGFloat?,
                                       CGFloat?) {
        return (cnMean?.getValue(dataType: dataType),
                demMean?.getValue(dataType: dataType),
                mciMean?.getValue(dataType: dataType))
    }
}

extension DataManager {
    func getData(dataType: DADataType) -> [DAData] {
        return self.managedData.compactMap { (key: Date, value: [DADataType : DAData]) in
            return value[dataType] != nil ? value[dataType] : nil
        }
    }
}

extension DataManager {
    func analysis() -> AnyPublisher<DementiaType, Never>? {
        // let features = Features(sleepBreathAverage: <#T##CGFloat#>,
        //          sleepHrAverage: <#T##CGFloat#>,
        //          sleepHrLowest: <#T##CGFloat#>,
        //          sleepDeep: <#T##CGFloat#>,
        //          sleepRem: <#T##CGFloat#>,
        //          activityCalTotal: <#T##CGFloat#>,
        //          sleepAwake: <#T##CGFloat#>,
        //          activitySteps: <#T##CGFloat#>,
        //          activityTotal: <#T##CGFloat#>,
        //          sleepDuration: <#T##CGFloat#>,
        //          activityDailyMovement: <#T##CGFloat#>)
        // model.send(features: features)
        return nil
    }
}
