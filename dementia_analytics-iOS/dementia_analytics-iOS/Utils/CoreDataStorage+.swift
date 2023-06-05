//
//  CoreDataStorage+.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/06.
//

import Combine
import CoreData
import CoreDataStorage

extension CoreDataStorage {
    func createAll<O>(_ values: [O]) -> AnyPublisher<[O], Error>
    where O: Entitable {
        let container = NSPersistentContainer(name: "DementiaDataStorage")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return Future<[O], Error> { promise in
            container.performBackgroundTask { context in
                values.forEach{ value in
                    _ = value.toEntity(in: context)
                }
                do {
                    try context.save()
                    promise(.success(values))
                } catch {
                    promise(.failure(CoreDataStorageError.createError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
