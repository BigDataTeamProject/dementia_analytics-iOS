//
//  DataManager.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import Foundation
import Combine

final class DataManager {
    static let shared = DataManager()
    private let model = DementiaAnalyticsModel.shared
    var auth: Bool {
        model.auth
    }
    var cnMean: Features? = nil
    var mciMean: Features? = nil
    var demMean: Features? = nil
    
    private init() {
        load()
    }
    
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
    }
    
    func mean(dataType:DADataType) -> (CGFloat?,
                                       CGFloat?,
                                       CGFloat?) {
        return (cnMean?.getValue(dataType: dataType),
                demMean?.getValue(dataType: dataType),
                mciMean?.getValue(dataType: dataType))
    }
    
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
        // model.send(features: <#T##Features#>)
        return nil
    }
}
