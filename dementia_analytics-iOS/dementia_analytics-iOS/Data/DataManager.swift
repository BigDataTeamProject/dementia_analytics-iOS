//
//  DataManager.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import Foundation
import Moya
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
    
    private var cnData: [DAData] = []
    private var mciData: [DAData] = []
    private var demData: [DAData] = []
    
    
    var auth: Bool {
        model.auth
    }
    var cnMean: Features? = nil
    var mciMean: Features? = nil
    var demMean: Features? = nil
    
    private init() { }
    
    func load(){
        loadMeanJson()
        loadTestJson()
        loadHealthKitData()
        loadManagedData()
    }
    
    func loadMeanJson(){
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
    }
    
    func loadTestJson(){
        guard let fileLocation = Bundle.main.url(forResource: "testData", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: fileLocation)
            guard let testData = try? JSONDecoder().decode([String: [String:Features]].self,
                                                           from: data)
            else { return }
            let cn = testData["CN"]!.compactMap{ (key, value) in
                value.toDAData(key.toDate())
            }
            self.cnData = cn[0]+cn[1]+cn[2]
            let dem = testData["DEM"]!.compactMap{ (key, value) in
                value.toDAData(key.toDate())
            }
            self.demData = dem[0]+dem[1]+dem[2]
            let mci = testData["CN"]!.compactMap{ (key, value) in
                value.toDAData(key.toDate())
            }
            self.mciData = mci[0]+mci[1]+mci[2]
            
        } catch {
            print(error)
        }
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
    
    private func loadManagedDataPublisher() -> AnyPublisher<Bool, Never> {
        return Future<Bool, Never>{ promise in
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
                    promise(.success(true))
                }
                .store(in: &self.cancellabel)
        }
        .eraseToAnyPublisher()
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
        .flatMap { result -> AnyPublisher<Bool, Never> in
            self.loadManagedDataPublisher()
                .map { _ in result }
                .eraseToAnyPublisher()
        }
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
        .flatMap { result -> AnyPublisher<Bool, Never> in
            self.loadManagedDataPublisher()
                .map { _ in result }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
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
    func analysis() -> AnyPublisher<DementiaType?, Never>? {
        var recentData: [DADataType: DAData] = [:]
        self.managedData.forEach{ (key, value) in
            value.forEach { (k, v) in
                if recentData[v.type] == nil {
                    recentData[v.type] = v
                } else {
                    if recentData[v.type]!.startDate < v.startDate {
                        recentData[v.type] = v
                    }
                }
            }
        }
        guard let sleepBreathAverage = recentData[.sleepBreathAverage]?.value,
              let sleepHrAverage = recentData[.sleepHrAverage]?.value,
              let sleepHrLowest = recentData[.sleepHrLowest]?.value,
              let sleepDeep = recentData[.sleepDeep]?.value,
              let sleepRem = recentData[.sleepRem]?.value,
              let activityCalTotal = recentData[.activityCalTotal]?.value,
              let sleepAwake = recentData[.sleepAwake]?.value,
              let activitySteps = recentData[.activitySteps]?.value,
              let activityTotal = recentData[.activityTotal]?.value,
              let sleepDuration = recentData[.sleepDuration]?.value,
              let activityDailyMovement = recentData[.activityDailyMovement]?.value else { return nil }
        let features = Features(sleepBreathAverage: sleepBreathAverage,
                                sleepHrAverage: sleepHrAverage,
                                sleepHrLowest: sleepHrLowest,
                                sleepDeep: sleepDeep,
                                sleepRem: sleepRem,
                                activityCalTotal: activityCalTotal,
                                sleepAwake: sleepAwake,
                                activitySteps: activitySteps,
                                activityTotal: activityTotal,
                                sleepDuration: sleepDuration,
                                activityDailyMovement: activityDailyMovement)
        let provider = MoyaProvider<APIService>()
        // let featuresData = features.toJSON()!
        let featuresData = Features.testDataCN.toJSON()!
        return provider.requestPublisher(.predict(featuresData))
            .map{ response -> Prediction? in
                print(response)
                return try? response.map(Prediction.self)
            }
            .mapError{ error in
                error as Error
            }
            .replaceError(with: nil)
            .map { pred -> DementiaType? in
                return pred?.dementiaType }
            .eraseToAnyPublisher()
    }
}

extension DataManager {
    func testing(_ type: DementiaType) -> AnyPublisher<Bool, Never>{
        var testData: [DAData] = []
        switch type {
        case .cn: testData = cnData
        case .dem: testData = demData
        case .mci: testData = mciData
        }
        return storage.deleteAll(DAData.self)
            .map { _ -> Bool in true }
            .replaceError(with: false)
            .flatMap { _ in
                self.storage.createAll(testData)
            }
            .map { _ -> Bool in true }
            .replaceError(with: false)
            .flatMap { result -> AnyPublisher<Bool, Never> in
                self.loadManagedDataPublisher()
                    .map { _ in result }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
